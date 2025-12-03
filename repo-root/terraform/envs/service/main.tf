module "network" {
  source               = "../../modules/network"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  azs                  = var.azs
  nat_eip_allocation_id = var.nat_eip_allocation_id
}

module "security" {
  source           = "../../modules/security"
  project_name     = var.project_name
  vpc_id           = module.network.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "rds" {
  source           = "../../modules/rds"
  project_name     = var.project_name
  db_subnet_ids    = module.network.private_subnet_ids
  vpc_security_ids = [module.security.db_sg_id]

  db_username = var.db_username
  db_password = var.db_password
  db_name     = var.db_name

  # 나머지 multi_az, backup_retention 등은 모듈 기본값 사용
}

module "efs" {
  source            = "../../modules/efs"
  project_name      = var.project_name
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.private_subnet_ids
  security_group_id = module.security.efs_sg_id
}

module "alb" {
  source         = "../../modules/alb"
  project_name   = var.project_name
  vpc_id         = module.network.vpc_id
  public_subnets = module.network.public_subnet_ids
  alb_sg_id      = module.security.alb_sg_id

  # ALB 삭제 보호 여부 (원하면 변수로 노출)
  enable_deletion_protection = true

  # 모니터링/로깅 제거: access_logs 관련 설정은 전달하지 않음
  # → enable_access_logs 기본값 + access_logs_bucket 빈 값으로 ALB Access log 비활성화
}

module "wordpress_asg" {
  source        = "../../modules/wordpress_asg"
  project_name  = var.project_name

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids
  web_sg_id  = module.security.web_sg_id

  instance_type    = var.instance_type
  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size

  target_group_arn   = module.alb.target_group_arn
  efs_file_system_id = module.efs.file_system_id

  db_name     = var.db_name
  db_user     = var.db_username
  db_password = var.db_password
  db_host     = module.rds.db_endpoint
}
