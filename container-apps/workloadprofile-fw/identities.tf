resource "azurerm_user_assigned_identity" "aca_identity" {
  name                = "${local.resource_name}-${local.app_name}-app-identity"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}
