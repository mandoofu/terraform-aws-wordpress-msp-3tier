locals {
  requester_route_table_map = {
    for idx, rt_id in var.requester_route_table_ids :
    idx => rt_id
  }

  accepter_route_table_map = {
    for idx, rt_id in var.accepter_route_table_ids :
    idx => rt_id
  }
}

resource "aws_vpc_peering_connection" "this" {
  vpc_id     = var.requester_vpc_id
  peer_vpc_id = var.accepter_vpc_id

  # 같은 계정/리전이면 auto_accept 가능
  auto_accept = true

  tags = {
    Name = "${var.project_name}-tools-to-service"
  }
}

# Tools VPC -> Service VPC
resource "aws_route" "requester_to_accepter" {
  for_each = local.requester_route_table_map

  route_table_id            = each.value
  destination_cidr_block    = var.accepter_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

# Service VPC -> Tools VPC
resource "aws_route" "accepter_to_requester" {
  for_each = local.accepter_route_table_map

  route_table_id            = each.value
  destination_cidr_block    = var.requester_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}
