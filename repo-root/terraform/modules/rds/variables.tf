variable "project_name" {
  type        = string
  description = "프로젝트 이름 (리소스 네이밍 prefix 로 사용)"
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "RDS 가 위치할 서브넷 ID 목록 (보통 private subnet)"
}

variable "vpc_security_ids" {
  type        = list(string)
  description = "RDS 에 붙일 Security Group ID 목록"
}

variable "db_name" {
  type        = string
  description = "초기 생성할 데이터베이스 이름 (WordPress 용)"
}

variable "db_username" {
  type        = string
  description = "DB master username"
}

variable "db_password" {
  type        = string
  description = "DB master password"
  sensitive   = true
}

variable "instance_class" {
  type        = string
  default     = "db.t3.small"
  description = "RDS 인스턴스 타입"
}

variable "allocated_storage" {
  type        = number
  default     = 20
  description = "RDS 기본 스토리지 용량 (GiB). IOPS/throughput 안 쓰면 20~100 사이 무난"
}

variable "storage_type" {
  type        = string
  default     = "gp3"
  description = "스토리지 타입 (gp2 / gp3 / io1 등). WordPress 용은 gp3 권장"
}

variable "multi_az" {
  type        = bool
  default     = false
  description = "Multi-AZ 배포 여부 (운영에서 고가용성이 필요하면 true)"
}

variable "backup_retention_period" {
  type        = number
  default     = 7
  description = "백업 보존 기간 (일 단위)"
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "RDS 삭제 보호 활성화 여부 (운영은 되도록 true 권장)"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "삭제 시 final snapshot 생략 여부 (운영에서는 false 권장)"
}

variable "apply_immediately" {
  type        = bool
  default     = true
  description = "변경사항을 즉시 적용할지 여부. 운영에서는 유지보수창이 있으면 false 로 두는 것도 검토"
}
