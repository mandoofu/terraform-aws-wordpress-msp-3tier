output "service_vpc_id" {
  value       = module.network.vpc_id
  description = "Service VPC ID"
}

output "service_vpc_cidr" {
  value       = var.vpc_cidr
  description = "Service VPC CIDR"
}

output "service_public_route_table_id" {
  value       = module.network.public_route_table_id
  description = "Service VPC public route table ID"
}

output "service_private_route_table_id" {
  value       = module.network.private_route_table_id
  description = "Service VPC private route table ID"
}

output "service_web_sg_id" {
  value       = module.security.web_sg_id
  description = "Service Web Security Group ID"
}

output "db_endpoint" {
  value       = module.rds.db_endpoint
  description = "RDS endpoint"
  sensitive   = true
}
