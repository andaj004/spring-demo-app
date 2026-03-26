output "control_plane_ips" {
  description = "Public IP addresses of control plane nodes"
  value       = module.compute.control_plane_ips
}

output "worker_ips" {
  description = "Public IP addresses of worker nodes"
  value       = module.compute.worker_ips
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = module.compute.alb_dns_name
}
