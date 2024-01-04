resource "azurerm_user_assigned_identity" "fleet_identity" {
  name                = "${local.fleet_name}-identity"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}