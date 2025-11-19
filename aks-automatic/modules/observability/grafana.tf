resource "azurerm_dashboard_grafana" "this" {
  depends_on = [
    azurerm_monitor_workspace.this
  ]
  count                             = var.enable_managed_offerings ? 1 : 0
  name                              = local.grafana_name
  resource_group_name               = azurerm_resource_group.this.name
  location                          = var.grafana_region
  sku                               = "Standard"
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true
  grafana_major_version             = 11
  zone_redundancy_enabled           = false

  identity {
    type = "SystemAssigned"
  }

  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.this[0].id
  }
}
