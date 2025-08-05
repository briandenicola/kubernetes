resource "azurerm_log_analytics_workspace" "this" {
  name                = "${local.resource_name}-logs"
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = azurerm_resource_group.monitoring.location
  sku                 = "PerGB2018"
  daily_quota_gb      = 0.5

}

resource "azurerm_log_analytics_solution" "this" {
  solution_name         = "ContainerInsights"
  resource_group_name   = azurerm_resource_group.monitoring.name
  location              = azurerm_resource_group.monitoring.location
  workspace_resource_id = azurerm_log_analytics_workspace.this.id
  workspace_name        = azurerm_log_analytics_workspace.this.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
