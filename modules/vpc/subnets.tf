# =============================================================================
# Public Subnets
# =============================================================================
resource "aws_subnet" "public" {
  count = local.public_subnet_count

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, var.subnet_newbits, count.index)
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    local.common_tags,
    local.kubernetes_tags,
    local.public_kubernetes_tags,
    {
      Name = "${var.name}-public-subnet-${local.azs[count.index]}"
      Type = "Public"
    }
  )
}

# =============================================================================
# Private Subnets
# =============================================================================
resource "aws_subnet" "private" {
  count = local.private_subnet_count

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_newbits, count.index + local.max_azs)
  availability_zone = local.azs[count.index]

  tags = merge(
    local.common_tags,
    local.kubernetes_tags,
    local.private_kubernetes_tags,
    {
      Name = "${var.name}-private-subnet-${local.azs[count.index]}"
      Type = "Private"
    }
  )
}
