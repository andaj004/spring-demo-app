# Referencing the existing VPC
data "aws_vpc" "existing_vpc" {
  id = "vpc-0736f5eac516efd42"  # Replace with your specific VPC ID
}

# Referencing the existing Security Group
data "aws_security_group" "existing_sg" {
  id = "sg-0a4eeaffccf59bad1"  # Replace with your specific SG ID
}

# Referencing existing Public Subnets
data "aws_subnet" "public_subnet_1" {
  id = "subnet-0d15716a1138b17ec"  # Replace with your first public subnet ID
}

data "aws_subnet" "public_subnet_2" {
  id = "subnet-02e14da80e4ba24bf"  # Replace with your second public subnet ID
}

# Creating Load Balancer for external access
resource "aws_lb" "prod_lb" {
  name               = "prod-lb"
  internal           = false  # Public load balancer
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.existing_sg.id]
  subnets            = [data.aws_subnet.public_subnet_1.id, data.aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false

  tags = {
    Name        = "prod-lb"
    Environment = "prod"
  }
}

# Creating Target Group for Load Balancer
resource "aws_lb_target_group" "prod_target_group" {
  name     = "prod-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.existing_vpc.id

  health_check {
    protocol = "HTTP"
    path     = "/healthz"
    port     = 80
    timeout  = 5
    interval = 30
  }

  tags = {
    Name = "prod-target-group"
  }
}

# Creating Load Balancer Listener
resource "aws_lb_listener" "prod_lb_listener" {
  load_balancer_arn = aws_lb.prod_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod_target_group.arn
  }
}

# Control Plane EC2 Instances (3 nodes for HA)
resource "aws_instance" "control_plane" {
  count              = 3
  ami                = "ami-0c7217cdde317cfec"  # Ubuntu 22.04 AMI
  instance_type      = "t3a.medium"
  key_name           = "spring-demo-devops"  # Replace with your key pair
  vpc_security_group_ids    = [data.aws_security_group.existing_sg.id]  # Corrected SG attach
  subnet_id          = data.aws_subnet.public_subnet_1.id  # Control plane in public subnet 1
  associate_public_ip_address = true
  user_data = <<-EOF
    #!/bin/bash
    # Install Kubernetes on Control Plane Nodes
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
    apt-get update -y
    apt-get install -y kubelet kubeadm kubectl
    # Initialize Kubernetes Cluster
    kubeadm init --control-plane-endpoint kube-api-prod:6443 --pod-network-cidr=10.244.0.0/16
    mkdir -p $HOME/.kube
    cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    chown $(id -u):$(id -g) $HOME/.kube/config
    kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
  EOF

  tags = {
    Name        = "ControlPlane-${count.index + 1}"
    Environment = "prod"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Worker EC2 Instances (2 nodes)
resource "aws_instance" "worker" {
  count              = 2
  ami                = "ami-0c7217cdde317cfec"  # Ubuntu 22.04 AMI
  instance_type      = "t3a.medium"
  key_name           = "spring-demo-devops"
  vpc_security_group_ids    = [data.aws_security_group.existing_sg.id]  # Corrected SG attach
  subnet_id          = data.aws_subnet.public_subnet_2.id  # Worker nodes in public subnet 2
  associate_public_ip_address = false
  user_data = <<-EOF
    #!/bin/bash
    # Install Kubernetes on Worker Nodes
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
    apt-get update -y
    apt-get install -y kubelet kubeadm kubectl
    # Join Kubernetes Cluster with the Control Plane
    kubeadm join <control-plane-endpoint> --token <token> --discovery-token-ca-cert-hash sha256:<hash>
  EOF

  tags = {
    Name        = "Worker-${count.index + 1}"
    Environment = "prod"
  }

  lifecycle {
    create_before_destroy = true
  }
}
