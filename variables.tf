variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-aks-cluster"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-cluster"
}

variable "node_vm_size" {
  description = "VM size for the default node pool"
  type        = string
  default     = "Standard_D2as_v7"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "acr_name" {
  description = "Globally unique name for the Azure Container Registry (alphanumeric only, no hyphens/underscores, 5-50 chars)"
  type        = string
  default     = "acraksclustersrk"
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace (unique within the resource group)"
  type        = string
  default     = "log-aks-cluster"
}

variable "local_account_disabled" {
  description = "Disable the cluster-local admin account, forcing all access through Entra ID. Set to true only after confirming Entra ID login works, to avoid lockout."
  type        = bool
  default     = true
}