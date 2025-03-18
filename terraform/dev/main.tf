# Referencing an existing VPC
data "aws_vpc" "existing_vpc" {
  id = "vpc-0736f5eac516efd42"  # Replace with your specific VPC ID
}

# Referencing an existing Security Group
data "aws_security_group" "existing_sg" {
  id = "sg-0a4eeaffccf59bad1"  # Replace with your specific SG ID
}

# Referencing existing Subnets in the VPC
data "aws_subnet" "public_subnet_1" {
  id = "subnet-0d15716a1138b17ec"  # Replace with your first public subnet ID
}

data "aws_subnet" "public_subnet_2" {
  id = "subnet-02e14da80e4ba24bf"  # Replace with your second public subnet ID
}

resource "aws_instance" "dev" {
  ami                = "ami-0c7217cdde317cfec"  # Ubuntu 22.04 AMI
  instance_type      = "t3a.medium"
  key_name           = "spring-demo-devops"
  vpc_security_group_ids    = [data.aws_security_group.existing_sg.id]  # Using the existing SG
  subnet_id          = data.aws_subnet.public_subnet_1.id  # Assign the subnet from the data source
  associate_public_ip_address = true  # Automatically assign a public IP
  user_data = <<-EOF
    #!/bin/bash
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -
    k3s kubectl create namespace dev
  EOF

  tags = {
    Name        = "Dev-EC2"
    Environment = "dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Allocating an Elastic IP and associating it with the EC2 instance
resource "aws_eip" "dev_eip" {
  instance = aws_instance.dev.id  # Associate the EIP with the EC2 instance

  tags = {
    Name = "Dev-ElasticIP"
  }
}
