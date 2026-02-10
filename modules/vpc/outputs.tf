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
  value       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  description = "Public subnet IDs"
}

output "private_subnet_ids" {
  value       = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  description = "Private subnet IDs"
}

output "public_route_table_id" {
  value       = aws_route_table.public_route_table.id
  description = "Public route table ID"
}

output "private_route_table_ids" {
  value       = [aws_route_table.private_route_table_1.id, aws_route_table.private_route_table_2.id]
  description = "Private route table IDs"
}

output "nat_gateway_ids" {
  value       = [aws_nat_gateway.nat_gateway_1.id, aws_nat_gateway.nat_gateway_2.id]
  description = "NAT Gateway IDs"
}

output "nat_eip_ids" {
  value       = [aws_eip.nat_eip_1.id, aws_eip.nat_eip_2.id]
  description = "EIP allocation IDs used by NAT Gateways"
}
