locals {
  zonal = var.region == "canadaeast" || var.region == "northcentralus" ? false : true
}

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
      zoneRedundant               = local.zonal
      
      vnetConfiguration = {
        infrastructureSubnetId = azurerm_subnet.nodes.id
        internal               = true
      }

      workloadProfiles = [
        {
          workloadProfileType = "Consumption",
          name                = "Consumption"
        },
        {
          minimumCount        = 3
          maximumCount        = 5
          name                = local.workload_profile_name
          workloadProfileType = local.workload_profile_size
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

resource "azapi_resource" "azurerm_container_app_httpbin" {
  name      = local.app_name
  type      = "Microsoft.App/containerApps@2023-04-01-preview"
  parent_id = azurerm_resource_group.this.id
  location  = azurerm_resource_group.this.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aca_identity.id
    ]
  }

  body = jsonencode({
    properties = {

      managedEnvironmentId = data.azurerm_container_app_environment.this.id
      workloadProfileName  = local.workload_profile_name
      configuration = {
        activeRevisionsMode = "Single"

        ingress = {
          allowInsecure = true
          external      = false
          targetPort    = 8080
          transport     = "http"
          traffic = [{
            latestRevision = true
            weight         = 100
          }]
        }
      }

      template = {
        containers = [{
          name  = local.app_name
          image = "docker.io/${local.container_image}"
          resources = {
            cpu    = 1
            memory = "2Gi"
          }
        }]
      }
    }
  })
}
