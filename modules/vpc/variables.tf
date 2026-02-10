variable "tag_environment" {
  type        = string
  description = "Environment tag"
}

variable "tag_ambiente" {
  type        = string
  description = "IAC tag"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name (used in subnet tags)"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs (2)"
  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "public_subnet_cidrs deve ter exatamente 2 itens."
  }
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs (2)"
  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "private_subnet_cidrs deve ter exatamente 2 itens."
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for subnets (2)"
  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "availability_zones deve ter exatamente 2 itens."
  }
}

variable "public_subnet_map_public_ip" {
  type        = bool
  description = "Auto-assign public IP on launch for public subnets"
}

variable "igw_name" {
  type        = string
  description = "Internet Gateway name"
}

variable "public_subnet_names" {
  type        = list(string)
  description = "Public subnet names (2)"
  validation {
    condition     = length(var.public_subnet_names) == 2
    error_message = "public_subnet_names deve ter exatamente 2 itens."
  }
}

variable "private_subnet_names" {
  type        = list(string)
  description = "Private subnet names (2)"
  validation {
    condition     = length(var.private_subnet_names) == 2
    error_message = "private_subnet_names deve ter exatamente 2 itens."
  }
}

variable "public_rt_name" {
  type        = string
  description = "Public route table name"
}

variable "private_rt_names" {
  type        = list(string)
  description = "Private route table names (2)"
  validation {
    condition     = length(var.private_rt_names) == 2
    error_message = "private_rt_names deve ter exatamente 2 itens."
  }
}

variable "nat_gateway_names" {
  type        = list(string)
  description = "NAT gateway names (2)"
  validation {
    condition     = length(var.nat_gateway_names) == 2
    error_message = "nat_gateway_names deve ter exatamente 2 itens."
  }
}

variable "nat_eip_names" {
  type        = list(string)
  description = "NAT EIP names (2)"
  validation {
    condition     = length(var.nat_eip_names) == 2
    error_message = "nat_eip_names deve ter exatamente 2 itens."
  }
}

variable "default_ipv4_cidr" {
  type        = string
  description = "Default IPv4 CIDR (e.g. 0.0.0.0/0)"
}
