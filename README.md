# AKS Cluster on Azure — Terraform

An Azure Kubernetes Service (AKS) cluster provisioned entirely via Terraform, built incrementally to practice enterprise-grade cluster infrastructure patterns: identity, secrets management, container registry integration, and observability — independent of any specific application.

## Current state

- Resource group and AKS cluster provisioned via Terraform, parameterized through `variables.tf`
- Default node pool with 2 nodes (`Standard_D2as_v7`), for practicing real multi-node scheduling behavior
- Cluster's own managed identity (`SystemAssigned`)
- OIDC issuer and Workload Identity enabled at the cluster level, in preparation for federated pod-level Azure authentication
- Azure Container Registry (Basic tier, admin user disabled), with the cluster's kubelet identity granted `AcrPull` — nodes can pull private images with no stored registry credentials
- Key Vault (RBAC-authorized, no legacy access policies, purge protection off to support a clean destroy/rebuild cycle) — infra only for now, no secrets or pod access wired up yet

## Structure

| File | Purpose |
|---|---|
| `providers.tf` | Provider version pin, provider configuration |
| `variables.tf` | Parameterized inputs (region, cluster name, node size, node count, ACR name, Key Vault name) |
| `rg.tf` | Resource group |
| `aks.tf` | AKS cluster and default node pool |
| `acr.tf` | Container Registry + `AcrPull` role assignment for the cluster's kubelet identity |
| `keyvault.tf` | Key Vault, RBAC-authorized |

## Roadmap

- [ ] Workload Identity federation, so a specific pod can read Key Vault secrets with no stored credentials
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
