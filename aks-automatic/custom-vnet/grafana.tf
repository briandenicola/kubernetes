resource "azurerm_dashboard_grafana" "this" {
  depends_on = [
    azurerm_monitor_workspace.this
  ]

  name                              = "${local.resource_name}-grafana"
  resource_group_name               = azurerm_resource_group.monitoring.name
  location                          = azurerm_resource_group.monitoring.location
  sku                               = "Standard"
  zone_redundancy_enabled           = true
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true
  grafana_major_version             = var.grafana_major_version

  identity {
    type = "SystemAssigned"
  }

  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.this.id
  }
}
