output "vpc_id" {
  value       = aws_vpc.terraform_vpc.id
  description = "VPC ID"
}

output "vpc_cidr_block" {
  value       = aws_vpc.terraform_vpc.cidr_block
  description = "VPC CIDR"
}

output "igw_id" {
  value       = aws_internet_gateway.terraform_igw.id
  description = "Internet Gateway ID"
}

output "public_subnet_ids" {
  value       = aws_subnet.public_subnets[*].id
  description = "Public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private_subnets[*].id
  description = "Private subnet IDs"
}

output "public_route_table_id" {
  value       = aws_route_table.public_rt.id
  description = "Public route table ID"
}

output "private_route_table_ids" {
  value       = aws_route_table.private_rts[*].id
  description = "Private route table IDs"
}

output "nat_gateway_ids" {
  value       = aws_nat_gateway.nat_gateways[*].id
  description = "NAT Gateway IDs"
}

output "nat_eip_ids" {
  value       = aws_eip.nat_eips[*].id
  description = "EIP allocation IDs used by NAT Gateways"
}