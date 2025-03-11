locals {
  zonal = var.region == "canadaeast" || var.region == "northcentralus" ? false : true
}

resource "azurerm_container_app_environment" "this" {
  name                           = local.aca_name
  location                       = azurerm_resource_group.this.location
  resource_group_name            = azurerm_resource_group.this.name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.this.id
  internal_load_balancer_enabled = false
  infrastructure_subnet_id       = azurerm_subnet.nodes.id
  zone_redundancy_enabled        = local.zonal
}
