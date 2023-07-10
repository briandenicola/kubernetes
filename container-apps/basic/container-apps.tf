resource "azurerm_container_app_environment" "this" {
  name                       = local.aca_name
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
}

resource "azurerm_container_app" "httpbin" {
  name                         = "httpbin"
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_resource_group.this.name
  revision_mode                = "Single"

  template {
    container {
      name   = "httpbin"
      image  = local.container_image
      cpu    = 1.0
      memory = "2Gi"
    }
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aca_identity.id
    ]
  }

  ingress {
    external_enabled           = true
    target_port                = 8080
    allow_insecure_connections = true

    traffic_weight {
      percentage = 100
    }
  }
}
