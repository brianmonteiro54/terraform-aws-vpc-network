# AWS VPC Terraform Module

Este módulo provisiona uma infraestrutura de rede completa na AWS.

## Recursos criados
* VPC com CIDR customizável.
* 2 Subnets Públicas (com IGW) para Load Balancers externos.
* 2 Subnets Privadas (com NAT Gateway).
* Tabelas de Rotas configuradas para alta disponibilidade.

## Como usar

```hcl
module "vpc" {
  source       = "[github.com/brianmonteiro54/terraform-aws-vpc-network](https://github.com/brianmonteiro54/terraform-aws-vpc-network)"
  cidr_block = "10.0.0.0/16
  # ... outras variáveis
}