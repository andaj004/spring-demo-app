resource "aws_instance" "control_plane" {
  count                       = var.control_plane_count
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.security_group_id]
  subnet_id                   = var.public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Name        = "ControlPlane-${var.env}-${count.index + 1}"
    Environment = var.env
    Role        = "control-plane"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "worker" {
  count                       = var.worker_count
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.security_group_id]
  subnet_id                   = var.public_subnets[1]
  associate_public_ip_address = true

  tags = {
    Name        = "Worker-${var.env}-${count.index + 1}"
    Environment = var.env
    Role        = "worker"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Creating Load Balancer for external access (only for environments that need it, e.g., prod)
resource "aws_lb" "main" {
  count              = var.create_alb ? 1 : 0
  name               = "${var.env}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Name        = "${var.env}-lb"
    Environment = var.env
  }
}

resource "aws_lb_target_group" "main" {
  count    = var.create_alb ? 1 : 0
  name     = "${var.env}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/"
    port     = 80
    timeout  = 5
    interval = 30
  }

  tags = {
    Name = "${var.env}-target-group"
  }
}

resource "aws_lb_listener" "main" {
  count             = var.create_alb ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }
}
