output "alb_arn" {
  value       = aws_lb.this.arn
  description = "ALB ARN"
}

output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "ALB DNS name"
}

output "alb_zone_id" {
  value       = aws_lb.this.zone_id
  description = "ALB zone ID"
}

output "target_group_arn" {
  value       = aws_lb_target_group.this.arn
  description = "Target group ARN"
}

output "target_group_name" {
  value       = aws_lb_target_group.this.name
  description = "Target group name"
}
