# Example: Complete VPC

This example provisions a complete AWS VPC with the following resources:

- VPC with DNS support enabled
- 3 public subnets (one per AZ)
- 3 private subnets (one per AZ)
- Internet Gateway for public subnets
- Single NAT Gateway for private subnet outbound traffic (cost-optimized for dev)
- Public and private route tables

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Inputs

| Name | Description | Default |
|------|-------------|---------|
| aws_region | AWS region | `us-east-1` |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| public_subnet_ids | List of public subnet IDs |
| private_subnet_ids | List of private subnet IDs |
| nat_gateway_public_ips | NAT Gateway public IPs |

> **Note:** This example uses `single_nat_gateway = true` to reduce costs.
> For production, consider `single_nat_gateway = false` for high availability.
