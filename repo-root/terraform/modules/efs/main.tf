resource "aws_efs_file_system" "this" {
  creation_token = "${var.project_name}-efs"
  encrypted      = true

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "${var.project_name}-efs"
  }
}

resource "aws_efs_mount_target" "this" {
  # subnet_ids 리스트를 인덱스 기반 map 으로 변환
  # → key(0,1,2,...) 는 plan 시점에 확정 가능하므로 for_each 에 안전하게 사용 가능
  for_each = {
    for idx, subnet_id in var.subnet_ids :
    idx => subnet_id
  }

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value

  # EFS Mount Target 은 list(string) 타입 요구 → string 변수를 리스트로 감싸서 전달
  security_groups = [var.security_group_id]
}
