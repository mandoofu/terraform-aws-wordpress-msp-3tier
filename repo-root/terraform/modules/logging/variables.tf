variable "project_name" {
  type        = string
  description = "Project name for resource naming"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to enable flow logs"
}

variable "enable_alb_logs" {
  type        = bool
  description = "Create S3 bucket and policy for ALB access logs"
  default     = true
}

variable "flow_logs_retention_days" {
  type        = number
  default     = 7
  description = "VPC Flow Logs retention in days"
}

variable "alb_logs_retention_days" {
  type        = number
  default     = 30
  description = "ALB access logs retention in days"
}
