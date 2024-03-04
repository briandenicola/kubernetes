resource "azapi_resource" "azurerm_container_app_environment" {
  depends_on = [
    azapi_update_resource.nodes_delegation
  ]

  type      = "Microsoft.App/managedEnvironments@2023-04-01-preview"
  name      = local.aca_name
  location  = azurerm_resource_group.this.location
  parent_id = azurerm_resource_group.this.id

  body = jsonencode({
    properties = {
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.this.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.this.primary_shared_key
        }
      }

      infrastructureResourceGroup = "${local.resource_name}_aca_nodes_rg"
      zoneRedundant               = true
      vnetConfiguration = {
        infrastructureSubnetId = azurerm_subnet.nodes.id
        internal               = true
      }

      workloadProfiles = [
        {
          workloadProfileType = local.workload_profile_name
          name                = local.workload_profile_name
        }]
    }
  })
}

data "azurerm_container_app_environment" "this" {
  depends_on = [
    azapi_resource.azurerm_container_app_environment
  ]
  name                = local.aca_name
  resource_group_name = azurerm_resource_group.this.name
}

# Note:
# -- workload_profiles is a part of azurerm_container_app_environment but if you want to use workload_profiles then you have to provide a HW profile
#
# resource "azurerm_container_app_environment" "this" {
#   name                            = local.aca_name
#   location                        = azurerm_resource_group.this.location
#   resource_group_name             = azurerm_resource_group.this.name
#   log_analytics_workspace_id      = azurerm_log_analytics_workspace.this.id
#   internal_load_balancer_enabled  = true
#   infrastructure_subnet_id        = azurerm_subnet.nodes.id
#
#   workload_profiles {
#     minimum_count                 = 3
#     maximum_count                 = 5
#     name                          = local.workload_profile_name
#     workload_profile_type         = local.workload_profile_size
#   }  
# }
