# =============================================================================
# VPC Gateway Endpoints (S3 and DynamoDB)
#
# Gateway endpoints route S3 and DynamoDB traffic over the AWS private backbone
# instead of through the NAT Gateway. AWS applies no hourly or data processing
# charge for gateway endpoints. They are associated with the private route
# tables so private subnets reach these services without incurring NAT data
# processing costs. To also route public-subnet traffic through the endpoint,
# add aws_route_table.public[*].id to route_table_ids.
# =============================================================================
resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-s3-endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.enable_dynamodb_endpoint ? 1 : 0

  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-dynamodb-endpoint"
    }
  )
}
