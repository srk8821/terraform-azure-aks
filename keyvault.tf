data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                       = var.key_vault_name
  resource_group_name        = azurerm_resource_group.aks.name
  location                   = azurerm_resource_group.aks.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  purge_protection_enabled   = false
}
