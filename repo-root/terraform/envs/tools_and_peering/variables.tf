variable "aws_region" {
  type    = string
  default = "ap-northeast-3"
}

variable "tools_project_name" {
  type    = string
  default = "tools"
}

variable "tools_vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "tools_public_subnets" {
  type        = list(string)
  description = "Tools VPC public subnet CIDRs"
  default     = ["10.10.0.0/24", "10.10.1.0/24"]
}

variable "tools_azs" {
  type        = list(string)
  description = "AZ list for Tools VPC"
  default     = ["ap-northeast-3a", "ap-northeast-3c"]
}

variable "ssh_key_name" {
  type        = string
  description = "EC2 key pair name for GitLab and Runner"
  default     = ""
}

# GitLab 외부 접속 허용 CIDR (예: 사무실 IP, VPN 등)
variable "gitlab_allowed_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to access GitLab HTTP/HTTPS"
  default     = ["0.0.0.0/0"] # 필요 시 좁혀 쓰는 걸 권장
}

# 관리용 SSH 접근 허용 CIDR
variable "admin_ssh_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to SSH into GitLab/Runner"
  default     = ["0.0.0.0/0"]
}

variable "gitlab_instance_type" {
  type        = string
  default     = "t3.medium"
  description = "Instance type for GitLab server"
}

variable "gitlab_disk_size" {
  type        = number
  default     = 100
  description = "Root disk size (GiB) for GitLab EC2"
}

variable "runner_instance_type" {
  type        = string
  default     = "t3.medium"
  description = "Instance type for GitLab Runner"
}

variable "runner_disk_size" {
  type        = number
  default     = 50
  description = "Root disk size (GiB) for Runner EC2"
}

############################
# 🔹 GitLab / Runner 모듈용 추가 변수
############################

# GitLab EXTERNAL_URL 에 사용할 호스트명
# 예: "gitlab.example.com" 또는 EC2 Public DNS
variable "gitlab_hostname" {
  type        = string
  description = "GitLab hostname used for EXTERNAL_URL (e.g. gitlab.example.com)"
}

# Runner 가 접속할 GitLab URL (http://... 형태)
# 보통 "http://<gitlab_hostname>" 와 동일하게 맞춤
variable "gitlab_external_url" {
  type        = string
  description = "GitLab URL used by Runner to connect (e.g. http://gitlab.example.com)"
}

# GitLab 에서 발급받은 Runner registration token
# (프로젝트/그룹/인스턴스 Runner 설정 화면에서 복사)
variable "gitlab_runner_registration_token" {
  type        = string
  description = "GitLab Runner registration token"
  sensitive   = true
}

# Runner 태그 (쉼표 구분)
# 예: "docker,tools"
variable "gitlab_runner_tags" {
  type        = string
  default     = "docker,tools"
  description = "Tags for GitLab Runner (comma-separated)"
}
