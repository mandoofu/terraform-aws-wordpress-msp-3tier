resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = { Name = "${var.project_name}-db-subnet-group" }
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.project_name}-mysql80-params"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }

  parameter {
    name  = "max_connections"
    value = "200"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = "2"
  }

  tags = {
    Name = "${var.project_name}-mysql80-params"
  }
}

resource "aws_db_instance" "this" {
  identifier = "${var.project_name}-mysql"

  engine = "mysql"
  # engine_version 는 아예 지정 안 해서, AWS 가 해당 리전의 8.0 최신 안정 버전 선택하게 둠

  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type     = var.storage_type
  # ⚠️ 여기에는 iops, storage_throughput 절대 넣지 마세요.
  # iops, storage_throughput 를 지정하려면 allocated_storage 를 400 이상으로 올려야 합니다.
  # 지금은 그냥 gp3 기본값으로 두는 게 안정적입니다.

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_ids

  multi_az               = var.multi_az
  publicly_accessible    = false
  deletion_protection    = var.deletion_protection
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  apply_immediately       = var.apply_immediately

  auto_minor_version_upgrade = true

  tags = {
    Name        = "${var.project_name}-mysql"
    Environment = "service"
    ManagedBy   = "terraform"
  }
}
