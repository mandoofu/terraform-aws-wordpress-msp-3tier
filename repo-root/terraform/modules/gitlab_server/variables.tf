variable "project_name" {
  type        = string
  description = "GitLab 서버 리소스 이름 prefix"
}

variable "vpc_id" {
  type        = string
  description = "GitLab 인스턴스가 들어갈 VPC ID"
}

variable "subnet_id" {
  type        = string
  description = "GitLab 인스턴스가 들어갈 서브넷 ID (보통 Public Subnet)"
}

variable "allowed_admin_cidr" {
  type        = string
  description = "SSH / 관리자 접속 허용 CIDR (예: 1.2.3.4/32)."
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "GitLab EC2 인스턴스 타입"
}

variable "root_volume_size" {
  type        = number
  default     = 100
  description = "루트 볼륨 크기(GiB). GitLab 데이터를 /srv/gitlab 에 두므로 100 이상 권장"
}

variable "gitlab_hostname" {
  type        = string
  description = "GitLab 호스트명 (EXTERNAL_URL, 예: gitlab.example.com 또는 EC2 Public DNS/IP)"
}

variable "key_name" {
  type        = string
  default     = ""
  description = "EC2 키페어 이름. 비워두면 SSH 키 없이 생성됨(SSM 전용)."
}
