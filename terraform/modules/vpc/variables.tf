variable "env" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "172.16.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets CIDR blocks"
  type        = list(string)
  default     = ["172.16.10.0/24", "172.16.20.0/24"]
}

variable "private_subnets" {
  description = "Private subnets CIDR blocks"
  type        = list(string)
  default     = ["172.16.30.0/24", "172.16.32.0/24"]
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
