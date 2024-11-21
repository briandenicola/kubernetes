
resource "azurerm_log_analytics_workspace" "this" {
  name                          = local.la_name
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  local_authentication_disabled = false
  sku                           = "PerGB2018"
  daily_quota_gb                = 10
}

resource "azurerm_application_insights" "this" {
  name                          = local.ai_name
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  application_type              = "web"
  workspace_id                  = azurerm_log_analytics_workspace.this.id
}
