provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../modules/vpc"

  env             = var.env
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "compute" {
  source = "../modules/compute"

  env                 = var.env
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnets
  security_group_id   = module.vpc.security_group_id
  control_plane_count = var.control_plane_count
  worker_count        = var.worker_count
  instance_type       = var.instance_type
  key_name            = var.key_name
  create_alb          = var.create_alb
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../templates/inventory.tmpl", {
    control_planes = module.compute.control_plane_ips
    workers        = module.compute.worker_ips
  })
  filename = "${path.module}/../../ansible/inventory/${var.env}/hosts.ini"
}
