output "control_plane_ips" {
  description = "Public IP addresses of control plane nodes"
  value       = aws_instance.control_plane[*].public_ip
}

output "worker_ips" {
  description = "Public IP addresses of worker nodes"
  value       = aws_instance.worker[*].public_ip
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = var.create_alb ? aws_lb.main[0].dns_name : null
}
