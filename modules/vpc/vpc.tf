# =============================================================================
# VPC
# =============================================================================
resource "aws_vpc" "this" {
  # checkov:skip=CKV2_AWS_11:VPC flow logging is optional and configurable via enable_flow_logs variable

  cidr_block = var.vpc_cidr

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-vpc"
    }
  )
}

# =============================================================================
# Default Security Group - Restrict all traffic (CKV2_AWS_12)
# =============================================================================
resource "aws_default_security_group" "default" {
  # checkov:skip=CKV2_AWS_12:Default SG restriction is managed here
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-default-sg-restricted"
    }
  )
}

# =============================================================================
# Internet Gateway
# =============================================================================
resource "aws_internet_gateway" "this" {
  count = var.enable_public_subnets ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-igw"
    }
  )
}

# =============================================================================
# Elastic IPs for NAT Gateways
# =============================================================================
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : local.private_subnet_count) : 0

  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = var.single_nat_gateway ? "${var.name}-nat-eip" : "${var.name}-nat-eip-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

# =============================================================================
# NAT Gateways
# =============================================================================
resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : local.private_subnet_count) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    local.common_tags,
    {
      Name = var.single_nat_gateway ? "${var.name}-nat-gw" : "${var.name}-nat-gw-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}
