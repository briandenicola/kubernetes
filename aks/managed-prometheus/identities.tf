resource "azurerm_user_assigned_identity" "app_identity" {
  name                = local.app_identity_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}
