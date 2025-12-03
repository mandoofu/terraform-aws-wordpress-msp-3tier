############################
# 1) Service 상태 읽기 (Remote State)
############################
data "terraform_remote_state" "service" {
  backend = "s3"

  config = {
    bucket = "terraform-state-a22f0d4f"   # service backend 와 동일
    key    = "service/terraform.tfstate"  # service backend 와 동일
    region = "ap-northeast-3"
  }
}

############################
# 2) Tools VPC 생성
############################
module "tools_network" {
  source          = "../../modules/network"
  project_name    = var.tools_project_name
  vpc_cidr        = var.tools_vpc_cidr
  public_subnets  = var.tools_public_subnets
  private_subnets = []        # 현재 NAT/Private subnet 불필요
  azs             = var.tools_azs

  # tools VPC 는 NAT EIP 불필요 → 빈 문자열
  nat_eip_allocation_id = ""
}

############################
# 3) Service VPC ↔ Tools VPC Peering
############################
locals {
  service_route_table_ids = compact([
    data.terraform_remote_state.service.outputs.service_public_route_table_id,
    data.terraform_remote_state.service.outputs.service_private_route_table_id
  ])

  tools_route_table_ids = [
    module.tools_network.public_route_table_id
  ]
}

module "vpc_peering" {
  source = "../../modules/vpc_peering"

  project_name = "${var.tools_project_name}-service-peering"

  requester_vpc_id = data.terraform_remote_state.service.outputs.service_vpc_id
  accepter_vpc_id  = module.tools_network.vpc_id

  requester_cidr = data.terraform_remote_state.service.outputs.service_vpc_cidr
  accepter_cidr  = var.tools_vpc_cidr

  requester_route_table_ids = local.service_route_table_ids
  accepter_route_table_ids  = local.tools_route_table_ids
}

############################
# 4) GitLab 서버 (모듈 호출)
############################
module "gitlab_server" {
  source = "../../modules/gitlab_server"

  # 네이밍 / VPC / 서브넷
  project_name = var.tools_project_name
  vpc_id       = module.tools_network.vpc_id
  subnet_id    = module.tools_network.public_subnet_ids[0]

  # 관리자 접속용 CIDR (기존 admin_ssh_cidrs 를 그대로 활용)
  allowed_admin_cidr = length(var.admin_ssh_cidrs) > 0 ? var.admin_ssh_cidrs[0] : "0.0.0.0/32"

  # EC2 스펙
  instance_type    = var.gitlab_instance_type
  root_volume_size = var.gitlab_disk_size

  # GitLab EXTERNAL_URL 에 사용될 호스트명 (도메인 또는 Public DNS/IP)
  gitlab_hostname = var.gitlab_hostname

  # 키페어 (있으면 SSH, 없으면 SSM 만 사용)
  key_name = var.ssh_key_name
}

############################
# 5) GitLab Runner (모듈 호출)
############################
module "gitlab_runner" {
  source = "../../modules/gitlab_runner"

  # 네이밍 / VPC / 서브넷
  project_name = var.tools_project_name
  vpc_id       = module.tools_network.vpc_id
  subnet_id    = module.tools_network.public_subnet_ids[0]

  # 관리자 SSH CIDR
  allowed_admin_cidr = length(var.admin_ssh_cidrs) > 0 ? var.admin_ssh_cidrs[0] : "0.0.0.0/32"

  # EC2 스펙
  instance_type    = var.runner_instance_type
  root_volume_size = var.runner_disk_size

  # GitLab URL + Runner 등록 토큰 (GitLab UI 에서 발급)
  gitlab_url         = var.gitlab_external_url
  registration_token = var.gitlab_runner_registration_token
  runner_tags        = var.gitlab_runner_tags

  # 키페어 (있으면 SSH, 없으면 SSM 만 사용)
  key_name = var.ssh_key_name
}

############################
# 6) Runner → Service Web SG 로 SSH 허용 (배포용)
############################
resource "aws_security_group_rule" "service_ssh_from_runner" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = data.terraform_remote_state.service.outputs.service_web_sg_id

  # 기존: aws_security_group.runner.id
  # 변경: gitlab_runner 모듈에서 runner_sg_id output 사용
  source_security_group_id = module.gitlab_runner.runner_sg_id

  description = "Allow SSH from GitLab Runner for deployments"
}
