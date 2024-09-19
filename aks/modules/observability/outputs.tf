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

output "DATA_COLLECTION_RULES_ID" {
  value     = azurerm_monitor_data_collection_rule.azuremonitor.id
  sensitive = false
}

output "DATA_COLLECTION_RULE_CONTAINER_INSIGHTS_ID" {
  value     = azurerm_monitor_data_collection_rule.container_insights.id
  sensitive = false
}

output "LOG_ANALYTICS_WORKSPACE_ID" {
  value     = azurerm_log_analytics_workspace.this.id
  sensitive = false
}