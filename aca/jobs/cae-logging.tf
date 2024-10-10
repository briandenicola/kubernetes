resource "azurerm_monitor_diagnostic_setting" "cae" {
  name                       = "diag"
  target_resource_id         = azapi_resource.azurerm_container_app_environment.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log  {
    category_group = "audit"
  }

  enabled_log  {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
