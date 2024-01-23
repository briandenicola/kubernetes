resource "azurerm_user_assigned_identity" "app_identity" {
  name                = "${local.resource_name}-otel-demo-identity"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}
