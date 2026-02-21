# =============================================================================
# Example: Complete VPC with public and private subnets
#
# This example shows a full VPC setup suitable for most workloads,
# including NAT Gateway for private subnet outbound connectivity.
#
# Usage:
#   terraform init
#   terraform plan
#   terraform apply
# =============================================================================

module "vpc" {
  source = "github.com/brianmonteiro54/terraform-aws-vpc-network//modules/rds?ref=main"

  # ---------------------------------------------------
  # Required
  # ---------------------------------------------------
  name        = "my-app"
  vpc_cidr    = "10.0.0.0/16"
  environment = "dev"

  # ---------------------------------------------------
  # Subnets (3 AZs by default)
  # ---------------------------------------------------
  enable_public_subnets  = true
  enable_private_subnets = true
  subnet_newbits         = 4 # Results in /20 subnets

  # Set to false to avoid public IPs being auto-assigned
  # on instances launched in public subnets
  map_public_ip_on_launch = false

  # ---------------------------------------------------
  # NAT Gateway
  # Set single_nat_gateway = true to save costs in dev
  # ---------------------------------------------------
  enable_nat_gateway = true
  single_nat_gateway = true

  # ---------------------------------------------------
  # Optional: Kubernetes (EKS) tag integration
  # ---------------------------------------------------
  enable_kubernetes_tags = false
  # cluster_name         = "my-eks-cluster"

  # ---------------------------------------------------
  # Tags
  # ---------------------------------------------------
  tags = {
    Project   = "my-app"
    Owner     = "platform-team"
    CostCenter = "engineering"
  }
}
