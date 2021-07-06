output "id" {
  value       = aws_lb.lb.id
  description = "ID of the ALB"
}

output "dns_name" {
  value       = aws_lb.lb.dns_name
  description = "DNS Name of the ALB"
}

output "arn" {
  value       = aws_lb.lb.arn
  description = "ARN of the ALB"
}

output "arn_suffix" {
  value       = aws_lb.lb.arn_suffix
  description = "ARN Suffix of the ALB"
}

output "zone_id" {
  value       = aws_lb.lb.zone_id
  description = "Zone ID of the ALB"
}

output "listener_http_arn" {
  value       = aws_lb_listener.lb_listener_http.arn
  description = "ARN of the HTTP listener"
}

output "listener_https_arn" {
  value       = var.ssl_certificate_arn == "" ? "" : join("", aws_lb_listener.lb_listener_https.*.arn)
  description = "ARN of the HTTPS listener (Note: optional depending on if a certificate is supplied)"
}

output "sg_id" {
  value       = aws_security_group.lb_sg.id
  description = "ID of the security group attached to the load balancer"
}

output "tg_id" {
  value       = aws_lb_target_group.lb_tg_http.id
  description = "ID of the target group which is attached to the load balancer"
}

output "tg_arn" {
  value       = aws_lb_target_group.lb_tg_http.arn
  description = "ARN of the target group which is attached to the load balancer"
}

output "tg_arn_suffix" {
  value       = aws_lb_target_group.lb_tg_http.arn_suffix
  description = "ARN suffix of the target group which is attached to the load balancer"
}

output "tg_egress_port" {
  value       = var.egress_port
  description = "Port that the target group is bound to send data over"
}
