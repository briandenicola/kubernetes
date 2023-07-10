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

//Table Update requires PATCH to change to Basic Plan but azapi_update_resource only does PUT updates 
resource "null_resource" "container_insights_basic_plan" {
  for_each = toset(local.container_insights_tables)
  depends_on = [
    azurerm_log_analytics_solution.this
  ]
  provisioner "local-exec" {
    command = "az monitor log-analytics workspace table update --resource-group ${azurerm_resource_group.this.name}  --workspace-name ${azurerm_log_analytics_workspace.this.name} --name ${each.key}  --plan Basic"
  }
}