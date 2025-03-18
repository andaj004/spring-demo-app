provider "aws" {
  region = "us-east-1"
}
# Creating VPC in AWS using terraform
module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "5.0.0"
  name            = "spring-demo-vpc"
  cidr            = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support  = true
  public_subnets  = ["172.16.10.0/24", "172.16.20.0/24"]
  private_subnets = ["172.16.30.0/24", "172.16.32.0/24"]
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  enable_nat_gateway = true
  enable_vpn_gateway = true

}
# --------------------------
# Creating Security Group in AWS using terraform
resource "aws_security_group" "sg" {
  name        = "spring-demo-sg"
  description = "Security group for Spring Demo App EC2 instances"
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
}
