resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "${var.project_name}-vpc" }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.project_name}-igw" }
}

#####################
# Public Subnets
#####################
resource "aws_subnet" "public" {
  for_each = {
    for idx, cidr in var.public_subnets :
    idx => cidr
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = var.azs[tonumber(each.key)]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-${each.key}"
    Tier = "public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = { Name = "${var.project_name}-public-rt" }
}

# 0.0.0.0/0 -> IGW
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

#####################
# NAT Gateway
#####################
# private_subnets 가 1개 이상 있을 때만 NAT 생성
# NAT용 EIP
# - private_subnets가 있고
# - nat_eip_allocation_id 를 따로 안 넘겼을 때만 새로 생성
resource "aws_eip" "nat" {
  count = (length(var.private_subnets) > 0 && var.nat_eip_allocation_id == "") ? 1 : 0

  domain = "vpc"

  tags = { Name = "${var.project_name}-nat-eip" }
}

resource "aws_nat_gateway" "this" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  # 기존 EIP를 넘겨줬으면 그 allocation_id 사용
  # 아니면 위에서 만든 aws_eip.nat[0].id 사용
  allocation_id = var.nat_eip_allocation_id != "" ? var.nat_eip_allocation_id : aws_eip.nat[0].id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = { Name = "${var.project_name}-nat-gw" }

  depends_on = [aws_internet_gateway.this]
}

#####################
# Private Subnets
#####################
resource "aws_subnet" "private" {
  for_each = {
    for idx, cidr in var.private_subnets :
    idx => cidr
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = var.azs[tonumber(each.key)]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-${each.key}"
    Tier = "private"
  }
}

# private RT는 있으면만 생성 (service VPC는 존재, tools VPC는 x)
resource "aws_route_table" "private" {
  count = length(var.private_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = { Name = "${var.project_name}-private-rt" }
}

# 0.0.0.0/0 -> NAT GW (private용)
resource "aws_route" "private_to_nat" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[0].id
}
