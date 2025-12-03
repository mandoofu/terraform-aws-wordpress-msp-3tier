variable "project_name" {
  type        = string
  description = "Runner 리소스 이름 prefix"
}

variable "vpc_id" {
  type        = string
  description = "Runner 인스턴스가 들어갈 VPC ID"
}

variable "subnet_id" {
  type        = string
  description = "Runner 인스턴스가 들어갈 서브넷 ID (보통 Public Subnet)"
}

variable "allowed_admin_cidr" {
  type        = string
  description = "SSH / 관리자 접속 허용 CIDR (예: 1.2.3.4/32)."
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "Runner EC2 인스턴스 타입"
}

variable "root_volume_size" {
  type        = number
  default     = 50
  description = "루트 볼륨 크기(GiB)"
}

variable "gitlab_url" {
  type        = string
  description = "GitLab URL (EXTERNAL_URL, 예: http://gitlab.example.com)"
}

variable "registration_token" {
  type        = string
  description = "GitLab에서 발급받은 Runner registration token"
  sensitive   = true
}

variable "runner_tags" {
  type        = string
  default     = "docker,tools"
  description = "Runner 태그 리스트 (쉼표 구분)"
}

variable "key_name" {
  type        = string
  default     = ""
  description = "EC2 키페어 이름. 비워두면 SSH 키 없이 생성됨(SSM 전용)."
}
