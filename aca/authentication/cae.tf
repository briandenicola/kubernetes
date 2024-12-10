resource "azurerm_container_app_environment" "this" {
  depends_on = [
    azapi_update_resource.nodes_delegation
  ]
  name                               = local.aca_name
  resource_group_name                = azurerm_resource_group.this.name
  location                           = azurerm_resource_group.this.location
  infrastructure_resource_group_name = "${local.resource_name}_aca_nodes_rg"
  infrastructure_subnet_id           = azurerm_subnet.nodes.id
  internal_load_balancer_enabled     = true
  zone_redundancy_enabled            = local.aca_zones
  log_analytics_workspace_id         = azurerm_log_analytics_workspace.this.id
  mutual_tls_enabled                 = true
  workload_profile {
    name                  = local.workload_profile_name
    workload_profile_type = local.workload_profile_name
  }
}
