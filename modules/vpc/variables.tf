# =============================================================================
# Required Variables
# =============================================================================
variable "name" {
  description = "Name to be used on all resources as identifier"
  type        = string
}

variable "vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

# =============================================================================
# Optional Variables - VPC Configuration
# =============================================================================
variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

# =============================================================================
# Optional Variables - Subnet Configuration
# =============================================================================
variable "max_availability_zones" {
  description = "Maximum number of availability zones to use for subnets"
  type        = number
  default     = 3

  validation {
    condition     = var.max_availability_zones > 0 && var.max_availability_zones <= 6
    error_message = "max_availability_zones must be between 1 and 6."
  }
}

variable "subnet_newbits" {
  description = "Number of additional bits to add to VPC CIDR for subnet calculation"
  type        = number
  default     = 4

  validation {
    condition     = var.subnet_newbits >= 1 && var.subnet_newbits <= 16
    error_message = "subnet_newbits must be between 1 and 16."
  }
}

variable "enable_public_subnets" {
  description = "Controls if public subnets should be created"
  type        = bool
  default     = true
}

variable "enable_private_subnets" {
  description = "Controls if private subnets should be created"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Should be true if you want to auto-assign public IP on instance launch in public subnets"
  type        = bool
  default     = true
}

# =============================================================================
# Optional Variables - NAT Gateway Configuration
# =============================================================================
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each private subnet"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all private subnets"
  type        = bool
  default     = false
}

# =============================================================================
# Optional Variables - Kubernetes Integration
# =============================================================================
variable "enable_kubernetes_tags" {
  description = "Should be true to add Kubernetes-specific tags to subnets"
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster (required if enable_kubernetes_tags is true)"
  type        = string
  default     = ""

  validation {
    condition     = !var.enable_kubernetes_tags || (var.enable_kubernetes_tags && var.cluster_name != "")
    error_message = "cluster_name must be provided when enable_kubernetes_tags is true."
  }
}

# =============================================================================
# Optional Variables - Tags
# =============================================================================
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
