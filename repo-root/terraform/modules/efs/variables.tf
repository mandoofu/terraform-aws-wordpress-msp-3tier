variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

# EFS SG 는 한 개 string 으로 받고, main.tf 에서 [ ] 로 감싸서 list 로 변환
variable "security_group_id" {
  type = string
}
