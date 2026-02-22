# AWS VPC Terraform Module

Este módulo provisiona uma infraestrutura de rede completa na AWS.

## Recursos criados
* VPC com CIDR customizável.
* 2 Subnets Públicas (com IGW) para Load Balancers externos.
* 2 Subnets Privadas (com NAT Gateway).
* Tabelas de Rotas configuradas para alta disponibilidade.

# 🌐 Terraform AWS VPC Network

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.9.0-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-~%3E%206.31-FF9900?logo=amazonaws)](https://registry.terraform.io/providers/hashicorp/aws/latest)

> **FIAP — Pós Tech · Tech Challenge — Fase 03 · ToggleMaster**
>
> Módulo Terraform reutilizável para provisionamento de **VPC completa** na AWS, incluindo subnets públicas/privadas, Internet Gateway, NAT Gateway e Route Tables.

---

## 📋 Descrição

Este módulo cria uma infraestrutura de rede completa e pronta para produção:

- **VPC** com CIDR configurável
- **Subnets públicas e privadas** distribuídas dinamicamente entre Availability Zones
- **Internet Gateway** para acesso público
- **NAT Gateway** (single ou multi-AZ) para acesso de saída das subnets privadas
- **Route Tables** com associações automáticas
- **Tags Kubernetes** opcionais para integração com EKS

---

## 🏗️ Arquitetura

```
┌──────────────────────── VPC ─────────────────────────┐
│                                                      │
│  ┌─── AZ-a ───────┐       ┌─── AZ-b ───────┐         │
│  │  Public Subnet │       │  Public Subnet │         │
│  │  ┌───────────┐ │       │                │         │
│  │  │ NAT GW    │ │       │                │         │
│  │  └───────────┘ │       │                │         │
│  └────────────────┘       └────────────────┘         │
│                                                      │
│  ┌─── AZ-a ───────┐       ┌─── AZ-b ───────┐         │
│  │  Private Subnet│       │  Private Subnet│         │
│  │  (EKS, RDS,    │       │  (EKS, RDS,    │         │
│  │   Redis, etc.) │       │   Redis, etc.) │         │
│  └────────────────┘       └────────────────┘         │
│                                                      │
│  ┌──────────────┐                                    │
│  │ Internet GW  │──── Route to 0.0.0.0/0             │
│  └──────────────┘                                    │
└──────────────────────────────────────────────────────┘
```

---

## 📦 Recursos Criados

| Recurso | Descrição |
|---------|-----------|
| `aws_vpc` | VPC com DNS support e hostnames habilitados |
| `aws_subnet` (públicas) | Subnets com auto-assign public IP |
| `aws_subnet` (privadas) | Subnets privadas para workloads |
| `aws_internet_gateway` | Gateway para tráfego de entrada/saída público |
| `aws_nat_gateway` | NAT para saída das subnets privadas |
| `aws_eip` | Elastic IP para o NAT Gateway |
| `aws_route_table` | Tabelas de rotas (pública e privada) |
| `aws_route_table_association` | Associação de subnets às route tables |

---

## 🚀 Uso

```hcl
module "vpc" {
  source = "git::https://github.com/brianmonteiro54/terraform-aws-vpc-network.git//modules/vpc?ref=<commit-sha>"

  name        = "ToggleMaster-production"
  vpc_cidr    = "10.0.0.0/20"
  environment = "production"

  max_availability_zones = 2
  subnet_newbits         = 4

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_kubernetes_tags = true
  cluster_name           = "ToggleMaster"

  tags = {
    Project   = "ToggleMaster"
    ManagedBy = "Terraform"
  }
}
```

---

## 📁 Estrutura

```
terraform-aws-vpc-network/
├── modules/
│   └── vpc/
│       ├── vpc.tf
│       ├── subnets.tf
│       ├── routes.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── locals.tf
│       └── data.tf
├── README.md
└── LICENSE
```
## 📄 Licença

[MIT License](LICENSE)
