variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
  default     = ["10.1.3.0/24", "10.1.4.0/24"]
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "control_plane_count" {
  description = "Number of control plane nodes"
  type        = number
  default     = 3
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3a.medium"
}

variable "key_name" {
  description = "SSH Key Name"
  type        = string
  default     = "spring-demo-devops"
}

variable "create_alb" {
  description = "Whether to create ALB"
  type        = bool
  default     = true
}
