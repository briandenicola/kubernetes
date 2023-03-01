resource "azurerm_log_analytics_workspace" "this" {
  name                = "${local.resource_name}-logs"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  daily_quota_gb      = 0.5
}

resource "azurerm_log_analytics_solution" "this" {
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  workspace_resource_id = azurerm_log_analytics_workspace.this.id
  workspace_name        = azurerm_log_analytics_workspace.this.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_application_insights" "this" {
  name                = "${local.resource_name}-appinsights"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  workspace_id        = azurerm_log_analytics_workspace.this.id
  application_type    = "web"
}

locals {
  container_insights_tables = ["ContainerLogV2"]
}

resource "azapi_resource_action" "this" {
  for_each    = toset(local.container_insights_tables)
  type        = "Microsoft.OperationalInsights/workspaces/tables@2022-10-01"
  resource_id = "${azurerm_log_analytics_workspace.this.id}/tables/${each.key}"
  method      = "PATCH"
  body        = jsonencode({
    properties = {
      plan = "Basic"
    }
  })

  depends_on = [
    azurerm_log_analytics_solution.this,
  ]
}