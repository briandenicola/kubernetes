locals {
  zonal = var.region == "canadaeast" || var.region == "northcentralus" ? false : true
}

resource "azurerm_container_app_environment" "this" {
  name                               = local.aca_name
  resource_group_name                = azurerm_resource_group.this.name
  location                           = azurerm_resource_group.this.location
  infrastructure_resource_group_name = "${local.resource_name}_aca_nodes_rg"
  infrastructure_subnet_id           = azurerm_subnet.nodes.id
  internal_load_balancer_enabled     = true
  zone_redundancy_enabled            = local.zonal
  log_analytics_workspace_id         = azurerm_log_analytics_workspace.this.id

  workload_profile {
    minimum_count         = 3
    maximum_count         = 5
    name                  = local.workload_profile_name
    workload_profile_type = local.workload_profile_size
  }

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
}


