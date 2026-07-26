resource "azurerm_log_analytics_workspace" "aks" {
  name                = var.log_analytics_workspace_name
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
