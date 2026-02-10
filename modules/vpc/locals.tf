locals {
  # Determine number of AZs to use
  max_azs = min(length(data.aws_availability_zones.available.names), var.max_availability_zones)
  azs     = slice(data.aws_availability_zones.available.names, 0, local.max_azs)

  # Calculate subnet counts
  public_subnet_count  = var.enable_public_subnets ? local.max_azs : 0
  private_subnet_count = var.enable_private_subnets ? local.max_azs : 0

  # Common tags merged with custom tags
  common_tags = merge(
    var.tags,
    {
      Name        = var.name
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  )

  # Kubernetes tags (optional)
  kubernetes_tags = var.enable_kubernetes_tags ? {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  } : {}

  # Public subnet kubernetes tags
  public_kubernetes_tags = var.enable_kubernetes_tags ? {
    "kubernetes.io/role/elb" = "1"
  } : {}

  # Private subnet kubernetes tags
  private_kubernetes_tags = var.enable_kubernetes_tags ? {
    "kubernetes.io/role/internal-elb" = "1"
  } : {}
}
