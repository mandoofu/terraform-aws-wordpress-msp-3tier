variable "project_name" { type = string }
variable "vpc_id" { type = string }
variable "public_subnets" { type = list(string) }
variable "alb_sg_id" { type = string }

variable "enable_deletion_protection" {
  type        = bool
  default     = true
  description = "Enable deletion protection for ALB"
}

variable "enable_http2" {
  type        = bool
  default     = true
  description = "Enable HTTP/2 on ALB"
}

variable "idle_timeout" {
  type        = number
  default     = 60
  description = "ALB idle timeout in seconds"
}

variable "access_logs_bucket" {
  type        = string
  default     = ""
  description = "S3 bucket name for ALB access logs"
}

variable "enable_access_logs" {
  type        = bool
  default     = true
  description = "Enable ALB access logs"
}

variable "certificate_arn" {
  type        = string
  default     = ""
  description = "ACM certificate ARN for HTTPS listener (optional)"
}

variable "enable_https" {
  type        = bool
  default     = false
  description = "Enable HTTPS listener (requires certificate_arn)"
}

variable "ssl_policy" {
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  description = "SSL policy for HTTPS listener"
}

variable "health_check_path" {
  type        = string
  default     = "/healthz.html"
  description = "Health check path"
}

variable "health_check_interval" {
  type        = number
  default     = 30
  description = "Health check interval in seconds"
}

variable "health_check_timeout" {
  type        = number
  default     = 5
  description = "Health check timeout in seconds"
}

variable "healthy_threshold" {
  type        = number
  default     = 2
  description = "Healthy threshold count"
}

variable "unhealthy_threshold" {
  type        = number
  default     = 2
  description = "Unhealthy threshold count"
}
