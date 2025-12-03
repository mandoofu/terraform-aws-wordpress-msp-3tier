variable "project_name" { type = string }
variable "vpc_cidr" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" {
  type    = list(string)
  default = []
}
variable "azs" { type = list(string) }
variable "nat_eip_allocation_id" {
  type        = string
  default     = ""   # 기본값: 새 EIP 생성
  description = "기존 탄력적 IP의 allocation ID. 지정하면 새 EIP를 만들지 않고 이 ID를 사용함."
}
