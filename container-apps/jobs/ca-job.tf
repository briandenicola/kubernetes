resource "azapi_resource" "azurerm_container_app_jobs" {
  name      = local.app_name
  type      = "Microsoft.App/jobs@2023-05-01"
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

      environmentId = data.azurerm_container_app_environment.this.id
      workloadProfileName  = local.workload_profile_name

      configuration = {
        triggerType          = "Schedule"
        replicaRetryLimit = 0
        replicaTimeout = 1800
        scheduleTriggerConfig = {
          cronExpression = "*/1 * * * *"
          parallelism = 1
          replicaCompletionCount = 1
        }
      }

      template = {
        containers = [{
          name  = local.app_name
          image = local.apps_image
          resources = {
            cpu    = 1
            memory = "2Gi"
          }
        }]
      }
    }
  })
}