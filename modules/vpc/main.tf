# =============================================================================
# Data Sources & Locals
# =============================================================================
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  common_tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
  }
}

# =============================================================================
# VPC & IGW
# =============================================================================
resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = merge(local.common_tags, {
    Name = var.vpc_name
  })
}

resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = merge(local.common_tags, {
    Name = var.igw_name
  })
}

# =============================================================================
# Public Subnets
# =============================================================================
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = var.public_subnet_map_public_ip

  tags = merge(local.common_tags, {
    Name                                        = var.public_subnet_names[count.index]
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
}

# =============================================================================
# Private Subnets
# =============================================================================
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(local.common_tags, {
    Name                                        = var.private_subnet_names[count.index]
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
}

# =============================================================================
# NAT Gateway & EIPs
# =============================================================================
resource "aws_eip" "nat_eips" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"
  tags   = { Name = var.nat_eip_names[count.index] }
}

resource "aws_nat_gateway" "nat_gateways" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat_eips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = merge(local.common_tags, {
    Name = var.nat_gateway_names[count.index]
  })
}

# =============================================================================
# Routing
# =============================================================================
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = var.default_ipv4_cidr
    gateway_id = aws_internet_gateway.terraform_igw.id
  }

  tags = merge(local.common_tags, { Name = var.public_rt_name })
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rts" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block     = var.default_ipv4_cidr
    nat_gateway_id = aws_nat_gateway.nat_gateways[count.index].id
  }

  tags = merge(local.common_tags, { Name = var.private_rt_names[count.index] })
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rts[count.index].id
}