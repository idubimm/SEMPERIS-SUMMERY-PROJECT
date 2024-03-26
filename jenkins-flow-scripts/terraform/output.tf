output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.custom_lb.dns_name
}


output "public_instances_public_ips_a" {
  value       = aws_instance.ec2_custom_public_compute_a.public_ip
  description = "The public IP addresses of the instances"
}
output "public_instances_public_ips_e" {
  value       = aws_instance.ec2_custom_public_compute_e.public_ip
  description = "The public IP addresses of the instances"
}
