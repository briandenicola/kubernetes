resource "azurerm_container_app" "utils" {
  
  lifecycle {
    ignore_changes = [
      secret,
      template[0].container[0].env
    ]
  }

  name                         = "utils"
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_resource_group.this.name
  revision_mode                = "Single"
  workload_profile_name        = local.workload_profile_name

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aca_identity.id
    ]
  }

  template {
    min_replicas = 1
    container {
      name   = "utils"
      image  = "docker.io/${local.utils_image}"
      cpu    = 1
      memory = "2Gi"
    }
  }
}