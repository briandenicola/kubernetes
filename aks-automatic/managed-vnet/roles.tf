resource "azurerm_role_assignment" "grafana_monitoring_read" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.this.identity[0].principal_id 
  skip_service_principal_aad_check = true 
}

resource "azurerm_role_assignment" "grafana_monitoring_data_read" {
  scope                = azurerm_monitor_workspace.this.id
  role_definition_name = "Monitoring Data Reader"
  principal_id         = azurerm_dashboard_grafana.this.identity[0].principal_id 
  skip_service_principal_aad_check = true 
}

resource "azurerm_role_assignment" "grafana_admin" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Grafana Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}
