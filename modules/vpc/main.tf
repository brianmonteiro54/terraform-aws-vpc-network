# =============================================================================
# locals
# =============================================================================
locals {
  common_tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
  }
}

# =============================================================================
# VPC
# =============================================================================
resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = merge(local.common_tags, {
    Name = var.vpc_name
  })
}

# =============================================================================
# Internet Gateway
# =============================================================================
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = merge(local.common_tags, {
    Name = var.igw_name
  })
}

# =============================================================================
# Public Subnets
# =============================================================================
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.public_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]

  map_public_ip_on_launch = var.public_subnet_map_public_ip

  tags = merge(local.common_tags, {
    Name                                        = var.public_subnet_names[0]
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.public_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]

  map_public_ip_on_launch = var.public_subnet_map_public_ip

  tags = merge(local.common_tags, {
    Name                                        = var.public_subnet_names[1]
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
}

# =============================================================================
# Private Subnets
# =============================================================================
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]

  tags = merge(local.common_tags, {
    Name                                        = var.private_subnet_names[0]
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]

  tags = merge(local.common_tags, {
    Name                                        = var.private_subnet_names[1]
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
}

# =============================================================================
# Public Route Table
# =============================================================================
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = var.default_ipv4_cidr
    gateway_id = aws_internet_gateway.terraform_igw.id
  }

  tags = merge(local.common_tags, {
    Name = var.public_rt_name
  })
}

resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# =============================================================================
# NAT Gateway
# =============================================================================
resource "aws_eip" "nat_eip_1" {
  domain = "vpc"
  tags = {
    Name = var.nat_eip_names[0]
  }
}

resource "aws_eip" "nat_eip_2" {
  domain = "vpc"
  tags = {
    Name = var.nat_eip_names[1]
  }
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = merge(local.common_tags, {
    Name = var.nat_gateway_names[0]
  })
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = merge(local.common_tags, {
    Name = var.nat_gateway_names[1]
  })
}

# =============================================================================
# Private Route Tables
# =============================================================================
resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block     = var.default_ipv4_cidr
    nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
  }

  tags = merge(local.common_tags, {
    Name = var.private_rt_names[0]
  })
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block     = var.default_ipv4_cidr
    nat_gateway_id = aws_nat_gateway.nat_gateway_2.id
  }

  tags = merge(local.common_tags, {
    Name = var.private_rt_names[1]
  })
}

resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_1.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id
}
