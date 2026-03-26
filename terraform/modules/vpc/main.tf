module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "5.0.0"
  name                 = "spring-demo-vpc-${var.env}"
  cidr                 = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  azs                  = var.azs
  enable_nat_gateway   = true
  enable_vpn_gateway   = true
}

resource "aws_security_group" "sg" {
  name        = "spring-demo-sg-${var.env}"
  description = "Security group for Spring Demo App EC2 instances (${var.env})"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Kubernetes API Server"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow all internal VPC traffic between nodes"
  }
}
