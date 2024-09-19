output "MONITOR_RESOURCE_GROUP" {
  value     = azurerm_resource_group.this.name
  sensitive = false
}

output "GRAFANA_RESOURCE_ID" {
  value     = azurerm_dashboard_grafana.this.id
  sensitive = false
}

output "AZURE_MONITOR_WORKSPACE_ID" {
  value     = azurerm_monitor_workspace.this.id
  sensitive = false
}

output "DATA_COLLECTION_ENDPOINT_ID" {
  value     = azurerm_monitor_data_collection_endpoint.this.id
  sensitive = false
}
