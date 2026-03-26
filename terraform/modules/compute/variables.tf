variable "env" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "control_plane_count" {
  description = "Number of control plane nodes"
  type        = number
  default     = 1
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3a.medium"
}

variable "ami" {
  description = "AMI ID"
  type        = string
  default     = "ami-0c7217cdde317cfec"
}

variable "key_name" {
  description = "SSH Key Name"
  type        = string
  default     = "spring-demo-devops"
}

variable "create_alb" {
  description = "Whether to create an Application Load Balancer"
  type        = bool
  default     = false
}
