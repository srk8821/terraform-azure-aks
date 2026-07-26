data "azurerm_client_config" "current" {}

# Grant the identity running Terraform (your az login account) cluster-admin
# via Azure RBAC, so Entra ID-based access works before the local account is
# disabled. Without this, setting local_account_disabled = true would lock
# everyone out of the cluster's data plane.
resource "azurerm_role_assignment" "aks_rbac_admin" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}
