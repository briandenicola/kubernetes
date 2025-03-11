locals {
  zonal = var.region == "canadaeast" || var.region == "northcentralus" ? false : true
}

resource "azapi_resource" "azurerm_container_app_environment" {
  depends_on = [
    azapi_update_resource.nodes_delegation
  ]

  type      = "Microsoft.App/managedEnvironments@2023-05-01"
  name      = local.aca_name
  location  = azurerm_resource_group.this.location
  parent_id = azurerm_resource_group.this.id

  body = {
    properties = {
      appLogsConfiguration = {
        destination = "azure-monitor"
      }
      
      daprAIConnectionString      = azurerm_application_insights.this.connection_string

      infrastructureResourceGroup = "${local.resource_name}_aca_nodes_rg"
      zoneRedundant               = local.zonal
      vnetConfiguration = {
        infrastructureSubnetId    = azurerm_subnet.nodes.id
        internal                  = true
      }

      peerAuthentication = {
        mtls = {
          enabled = true
        }
      }

      workloadProfiles = [
        {
          workloadProfileType = local.workload_profile_name
          name                = local.workload_profile_name
        }]
    }
  }
}

data "azurerm_container_app_environment" "this" {
  depends_on = [
    azapi_resource.azurerm_container_app_environment
  ]
  name                = local.aca_name
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_monitor_diagnostic_setting" "cae" {
  name                       = "diag"
  target_resource_id         = azapi_resource.azurerm_container_app_environment.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log  {
    category_group = "audit"
  }

  enabled_log  {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
