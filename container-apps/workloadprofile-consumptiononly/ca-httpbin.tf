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
          image = "docker.io/${local.apps_image}"
          resources = {
            cpu    = 1
            memory = "2Gi"
          }
        }]
      }
    }
  })
}
