# AKS Cluster on Azure — Terraform

An Azure Kubernetes Service (AKS) cluster provisioned entirely via Terraform, built incrementally to practice enterprise-grade cluster infrastructure patterns: identity, secrets management, container registry integration, and observability — independent of any specific application.

## Current state

- Resource group and AKS cluster provisioned via Terraform, parameterized through `variables.tf`
- Default node pool with 2 nodes (`Standard_D2as_v7`), for practicing real multi-node scheduling behavior
- Cluster's own managed identity (`SystemAssigned`)
- OIDC issuer and Workload Identity enabled at the cluster level, in preparation for federated pod-level Azure authentication
- Azure Container Registry (Basic tier, admin user disabled), with the cluster's kubelet identity granted `AcrPull` — nodes can pull private images with no stored registry credentials

## Structure

| File | Purpose |
|---|---|
| `providers.tf` | Provider version pin, provider configuration (incl. Key Vault purge-on-destroy behavior for future per-app vaults) |
| `variables.tf` | Parameterized inputs (region, cluster name, node size, node count, ACR name) |
| `rg.tf` | Resource group |
| `aks.tf` | AKS cluster and default node pool |
| `acr.tf` | Container Registry + `AcrPull` role assignment for the cluster's kubelet identity |

## Roadmap

- [ ] Azure RBAC for Kubernetes Authorization (Entra ID-based cluster access, no static admin credential)
- [ ] Log Analytics workspace + Container Insights for observability

## Deliberate scoping decisions

- **No Key Vault or Workload Identity federation at the cluster level.** Vaults and app identities are per-application concerns (one vault per app per environment, per Azure best practice) and will be provisioned alongside each app when real workloads are deployed. The cluster-level prerequisites (OIDC issuer, Workload Identity webhook) are enabled and ready.
- **Default networking.** VNet/subnet integration and private cluster access are out of scope for this phase.

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
