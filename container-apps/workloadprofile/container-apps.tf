# Note:
# -- workload_profiles is not part of azurerm as of 3.64
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


# Note"
# -- WorkloadProfiles configuration is not supported in api version. Use 2022-11-01-preview or above
# resource "azurerm_container_app" "httpbin" {
#   name                         = local.app_name
#   container_app_environment_id = data.azurerm_container_app_environment.this.id
#   resource_group_name          = azurerm_resource_group.this.name
#   revision_mode                = "Single"

#   template {
#     container {
#       name   = local.app_name
#       image  = local.container_image
#       cpu    = 1.0
#       memory = "2Gi"
#     }
#   }

#   identity {
#     type = "UserAssigned"
#     identity_ids = [
#       azurerm_user_assigned_identity.aca_identity.id
#     ]
#   }

#   ingress {
#     external_enabled           = false
#     target_port                = 8080
#     allow_insecure_connections = true

#     traffic_weight {
#       percentage = 100
#     }
#   }
# }


resource "azapi_resource" "azurerm_container_app_environment" {
  depends_on = [
    azapi_update_resource.nodes_delegation
  ]

  type      = "Microsoft.App/managedEnvironments@2022-11-01-preview"
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

      vnetConfiguration = {
        infrastructureSubnetId = azurerm_subnet.nodes.id
        internal               = true
      }

      workloadProfiles = [{
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
  type      = "Microsoft.App/containerApps@2022-11-01-preview"
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
