variable "aws_region" {
  type    = string
  default = "ap-northeast-3"
}

variable "project_name" {
  type    = string
  default = "service-wp"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["ap-northeast-3a", "ap-northeast-3c"]
}

variable "nat_eip_allocation_id" {
  type        = string
  default     = ""  # 기본은 새 EIP 생성
  description = "기존 NAT용 EIP allocation ID. 빈 문자열이면 새 EIP를 생성합니다."
}

# Database variables
variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type    = string
  default = "wordpress"
}

# Security variables
variable "allowed_ssh_cidr" {
  type        = string
  default     = ""
  description = "Allowed CIDR for SSH access (leave empty for SSM-only access)"
}

# EC2 variables
variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 6
}

# RDS enhanced variables
variable "rds_instance_class" {
  type        = string
  default     = "db.t3.small"
  description = "RDS instance class"
}

variable "rds_allocated_storage" {
  type        = number
  default     = 20
  description = "Initial storage size in GB"
}

variable "rds_max_allocated_storage" {
  type        = number
  default     = 100
  description = "Maximum storage size for autoscaling in GB"
}

variable "rds_multi_az" {
  type        = bool
  default     = true
  description = "Enable Multi-AZ for production (set false for dev/test)"
}

variable "rds_backup_retention_period" {
  type        = number
  default     = 7
  description = "Backup retention period in days"
}

variable "rds_deletion_protection" {
  type        = bool
  default     = true
  description = "Enable deletion protection for production"
}

variable "rds_skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Skip final snapshot on deletion (set true only for dev)"
}

variable "rds_performance_insights_enabled" {
  type        = bool
  default     = true
  description = "Enable Performance Insights"
}

# ALB enhanced variables
variable "alb_deletion_protection" {
  type        = bool
  default     = true
  description = "Enable deletion protection for ALB"
}

variable "enable_alb_access_logs" {
  type        = bool
  default     = true
  description = "Enable ALB access logs"
}

variable "enable_https" {
  type        = bool
  default     = false
  description = "Enable HTTPS listener (requires ACM certificate)"
}

variable "certificate_arn" {
  type        = string
  default     = ""
  description = "ACM certificate ARN for HTTPS (leave empty if HTTPS not enabled)"
}

