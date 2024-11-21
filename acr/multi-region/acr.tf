resource "azurerm_container_registry" "this" {
  name                     = local.acr_name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  sku                      = "Premium"
  admin_enabled            = false
  data_endpoint_enabled    = true 

  dynamic "georeplications" {
    for_each = slice(var.regions, 1, length(var.regions)) # Skip the first region
    iterator = each
    content {
      location                = each.value
    }
  } 

  network_rule_set {
    default_action = "Deny"
    ip_rule {
      action   = "Allow"
      ip_range = local.authorized_ip_ranges
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                        = "diag"
  target_resource_id          = azurerm_container_registry.this.id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "ContainerRegistryRepositoryEvents"
  }

  enabled_log {
    category = "ContainerRegistryLoginEvents"
  }
  
  metric {
    category = "AllMetrics"
  }
}


