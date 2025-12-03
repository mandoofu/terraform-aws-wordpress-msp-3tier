output "asg_name" {
  value       = aws_autoscaling_group.this.name
  description = "Auto Scaling Group name"
}

output "asg_arn" {
  value       = aws_autoscaling_group.this.arn
  description = "Auto Scaling Group ARN"
}

output "launch_template_id" {
  value       = aws_launch_template.this.id
  description = "Launch Template ID"
}
