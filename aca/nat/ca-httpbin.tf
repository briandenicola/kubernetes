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

  body = {
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
  }
}

data "azurerm_container_app" "httpbin" {
  depends_on = [
    azapi_resource.azurerm_container_app_httpbin
  ]
  name                = local.app_name
  resource_group_name = azurerm_resource_group.this.name
}