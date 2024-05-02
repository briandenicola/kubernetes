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
  revision_mode                = "Multiple"

  template {
    container {
      name   = "httpbin"
      image  = local.container_image
      cpu    = 1.0
      memory = "2Gi"
    }
    min_replicas = 1
    max_replicas = 3
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

    dynamic "traffic_weight" {
      for_each = var.ingress_labels
      content {
        label           = traffic_weight.value.label
        revision_suffix = traffic_weight.value.revision_suffix
        percentage      = traffic_weight.value.traffic_weight
        latest_revision = traffic_weight.value.latest_revision
      } 
    }
  }
}
