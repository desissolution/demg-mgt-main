# demg-mgt-main

Terraform module that deploys a demo environment to Azure, managed via GitHub Actions CI/CD with Workload Identity Federation (OIDC). Based on the [Azure-Samples/github-terraform-oidc-ci-cd](https://github.com/Azure-Samples/github-terraform-oidc-ci-cd) sample.

## What This Deploys

| Resource | Module | Description |
|---|---|---|
| Resource Group | `avm-res-resources-resourcegroup` | Optional resource group for the environment |
| Virtual Network | `avm-res-network-virtualnetwork` | VNet with configurable subnets and address space |
| Virtual Machine | `avm-res-compute-virtualmachine` | Linux VM (Ubuntu 22.04) with configurable SKU |

## Repository Structure

| File / Folder | Purpose |
|---|---|
| `main.tf` | Root module — declares the resource group, virtual network, and virtual machine modules |
| `variables.tf` | Input variable definitions (location, naming, network, VM SKU, tags) |
| `locals.tf` | Computes resource names from templates using workload, environment, location, and sequence |
| `terraform.tf` | Provider and backend configuration (AzureRM with remote state in Azure Storage via Entra ID) |
| `config/dev.tfvars` | Variable values for the **dev** environment |
| `config/test.tfvars` | Variable values for the **test** environment |
| `config/prod.tfvars` | Variable values for the **prod** environment |
| `.github/workflows/ci.yaml` | CI pipeline — runs `terraform validate` and `terraform plan` on pull requests |
| `.github/workflows/cd.yaml` | CD pipeline — runs `terraform plan` and `terraform apply` on merge to `main` |

## CI/CD Pipeline

- **Authentication**: OIDC via Azure User Assigned Managed Identities (no secrets stored in GitHub)
- **State Management**: Remote state in Azure Storage Account (`stodemgmgtwus2001rqp`) using Entra ID auth
- **Environments**: `dev` → `test` → `prod`, each with separate plan and apply identities (least privilege)
- **CI (Pull Request)**: Validates Terraform formatting, runs `terraform plan` for all environments
- **CD (Merge to main)**: Runs `terraform plan` then `terraform apply` sequentially through dev → test → prod
- **Governed Pipelines**: Workflows use reusable templates from `desissolution/demg-mgt-template`, enforced via federated credential subject claims

## Prerequisites

- [Terraform CLI](https://www.terraform.io/downloads)
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- An [Azure Subscription](https://azure.microsoft.com/pricing/purchase-options/azure-account)
- A [GitHub Organization](https://github.com/organizations/plan)

## References

- [Azure-Samples/github-terraform-oidc-ci-cd](https://github.com/Azure-Samples/github-terraform-oidc-ci-cd)
- [GitHub OIDC with Azure](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-cloud-providers)
- [Terraform AzureRM OIDC Guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_oidc)
