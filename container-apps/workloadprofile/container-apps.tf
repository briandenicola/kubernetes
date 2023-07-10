resource "azurerm_container_app_environment" "this" {
  name                           = local.aca_name
  location                       = azurerm_resource_group.this.location
  resource_group_name            = azurerm_resource_group.this.name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.this.id
  internal_load_balancer_enabled = true
  infrastructure_subnet_id       = azurerm_subnet.nodes.id
  //enable_workload_profiles       = true  #Not yet available in TF
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
    external_enabled           = false
    target_port                = 8080
    allow_insecure_connections = true

    traffic_weight {
      percentage = 100
    }
  }
}
