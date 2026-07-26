# AKS Cluster on Azure — Terraform

An Azure Kubernetes Service (AKS) cluster provisioned entirely via Terraform, built to practice enterprise-grade cluster infrastructure patterns: identity-based access throughout (managed identities, Entra ID, Azure RBAC), private container registry integration, and observability — app-agnostic, no application coupled to the infrastructure.

## What this provisions

- **Resource group + AKS cluster**, fully parameterized through `variables.tf`
- **Multi-node pool** — 2 × `Standard_D2as_v7`, for exercising real pod scheduling / drain behavior rather than a single-node toy
- **Cluster identity** (`SystemAssigned`) for control-plane operations, plus **OIDC issuer + Workload Identity** enabled, ready for per-app federated pod identity later
- **Azure Container Registry** (Basic, admin user disabled) with the cluster's **kubelet identity** granted `AcrPull` — nodes pull private images with no stored registry credentials
- **Log Analytics workspace + Container Insights** (`oms_agent`) — node/pod/container telemetry to a central workspace; collector runs as a per-node DaemonSet (`ama-logs`)
- **Entra ID authentication + Azure RBAC for Kubernetes authorization**, with the **local admin account disabled** — all cluster access flows through Entra ID identities and Azure role assignments; no static admin kubeconfig exists

## Identity model

Every access path is identity-based, no stored secrets:

| Actor | Identity | Grants |
|---|---|---|
| Terraform (provisioning) | Your `az login` identity (ARM) | Subscription-level, management plane only |
| Cluster control plane | Cluster `SystemAssigned` identity | Manages its own supporting Azure resources |
| Node kubelet (image pulls) | Kubelet managed identity | `AcrPull`, scoped to the one registry |
| Human `kubectl` access | Entra ID identity | `Azure Kubernetes Service RBAC Cluster Admin`, scoped to the one cluster |

## Structure

| File | Purpose |
|---|---|
| `providers.tf` | Provider version pin, provider configuration (incl. Key Vault / Log Analytics purge-on-destroy) |
| `variables.tf` | Parameterized inputs (region, names, node size/count, `local_account_disabled` toggle) |
| `rg.tf` | Resource group |
| `aks.tf` | AKS cluster, node pool, Container Insights, Entra ID + Azure RBAC config |
| `acr.tf` | Container Registry + `AcrPull` role assignment for the kubelet identity |
| `monitoring.tf` | Log Analytics workspace backing Container Insights |
| `rbac.tf` | Cluster-admin Azure RBAC role assignment for the provisioning identity |
| `outputs.tf` | Cluster name, ACR login server, OIDC issuer URL, workspace ID, get-credentials command |

## Deliberate scoping decisions

- **No Key Vault or Workload Identity federation at the cluster level.** Vaults and app identities are per-application concerns (one vault per app per environment, per Azure best practice) and belong alongside each app when real workloads are deployed. The cluster-level prerequisites (OIDC issuer, Workload Identity webhook) are enabled and ready.
- **Default networking.** VNet/subnet integration and private cluster access are out of scope for this phase.

## Running it

```bash
az login
terraform init
terraform apply
```

Because the local admin account is disabled, cluster access is through Entra ID. Configure `kubectl`, then convert the kubeconfig to reuse your existing `az` session (avoids an interactive device-code login on every command):

```bash
az aks get-credentials --resource-group rg-aks-cluster --name aks-cluster --overwrite-existing
kubelogin convert-kubeconfig -l azurecli
kubectl get nodes
```

Tear down between sessions to avoid ongoing cost:

```bash
terraform destroy
```
