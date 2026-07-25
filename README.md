# AKS Cluster on Azure — Terraform

An Azure Kubernetes Service (AKS) cluster provisioned entirely via Terraform, built incrementally to practice enterprise-grade cluster infrastructure patterns: identity, secrets management, container registry integration, and observability — independent of any specific application.

## Current state

- Resource group and AKS cluster provisioned via Terraform, parameterized through `variables.tf`
- Single system node pool (`Standard_D2as_v7`)
- Cluster's own managed identity (`SystemAssigned`)
- OIDC issuer and Workload Identity enabled at the cluster level, in preparation for federated pod-level Azure authentication

## Structure

| File | Purpose |
|---|---|
| `providers.tf` | Provider version pin, provider configuration |
| `variables.tf` | Parameterized inputs (region, cluster name, node size, node count) |
| `rg.tf` | Resource group |
| `aks.tf` | AKS cluster and default node pool |

## Roadmap

- [ ] Azure Container Registry (ACR), integrated via managed identity
- [ ] Key Vault, with Workload Identity federation for secretless pod access
- [ ] Azure RBAC for Kubernetes Authorization (Entra ID-based cluster access, no static admin credential)
- [ ] Log Analytics workspace + Container Insights for observability

## Running it

```bash
az login
terraform init
terraform plan
terraform apply
az aks get-credentials --resource-group <rg-name> --name <cluster-name>
kubectl get nodes
```

Networking uses AKS defaults for now; VNet/subnet integration and private cluster access are deliberately out of scope for this phase.
