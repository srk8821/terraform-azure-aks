output "resource_group_name" {
  description = "Name of the resource group containing the cluster"
  value       = azurerm_resource_group.aks.name
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL, needed when federating per-app Workload Identities later"
  value       = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}

output "acr_login_server" {
  description = "Login server hostname for the container registry (used when tagging/pushing images)"
  value       = azurerm_container_registry.acr.login_server
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace backing Container Insights"
  value       = azurerm_log_analytics_workspace.aks.id
}

output "get_credentials_command" {
  description = "Convenience command to configure kubectl for this cluster"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.aks.name} --name ${azurerm_kubernetes_cluster.aks.name} --overwrite-existing"
}
