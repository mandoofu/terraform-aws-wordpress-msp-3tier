output "vpc_flow_logs_group_name" {
  value       = aws_cloudwatch_log_group.vpc_flow_logs.name
  description = "VPC Flow Logs CloudWatch Log Group name"
}

output "alb_logs_bucket_name" {
  value       = var.enable_alb_logs ? aws_s3_bucket.alb_logs[0].bucket : ""
  description = "ALB access logs S3 bucket name"
}

output "alb_logs_bucket_arn" {
  value       = var.enable_alb_logs ? aws_s3_bucket.alb_logs[0].arn : ""
  description = "ALB access logs S3 bucket ARN"
}
