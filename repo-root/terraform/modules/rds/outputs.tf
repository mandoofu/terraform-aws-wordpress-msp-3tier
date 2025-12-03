output "db_endpoint" {
  value       = aws_db_instance.this.address
  description = "RDS instance endpoint address"
}

output "db_instance_id" {
  value       = aws_db_instance.this.identifier
  description = "RDS instance identifier"
}

output "db_arn" {
  value       = aws_db_instance.this.arn
  description = "RDS instance ARN"
}

output "db_port" {
  value       = aws_db_instance.this.port
  description = "RDS instance port"
}
