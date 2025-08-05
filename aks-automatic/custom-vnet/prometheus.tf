resource "azurerm_monitor_workspace" "this" {
  name                = local.azuremonitor_workspace_name
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = azurerm_resource_group.monitoring.location
}

resource "azurerm_monitor_data_collection_endpoint" "this" {
  name                          = "${local.resource_name}-ama-datacollection-ep"
  resource_group_name           = azurerm_resource_group.monitoring.name
  location                      = azurerm_resource_group.monitoring.location
  kind                          = "Linux"
  public_network_access_enabled = true
}

resource "azurerm_monitor_data_collection_rule" "azuremonitor" {
  depends_on = [
    azurerm_monitor_workspace.this,
    azurerm_monitor_data_collection_endpoint.this
  ]

  name                        = "${local.resource_name}-ama-datacollection-rules"
  resource_group_name         = azurerm_resource_group.monitoring.name
  location                    = azurerm_resource_group.monitoring.location
  kind                        = "Linux"
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.this.id

  destinations {
    monitor_account {
      monitor_account_id = azurerm_monitor_workspace.this.id
      name               = "MonitoringAccount"
    }
  }

  data_flow {
    destinations = ["MonitoringAccount"]
    streams      = ["Microsoft-PrometheusMetrics"]
  }

  data_sources {
    prometheus_forwarder {
      name    = "PrometheusDataSource"
      streams = ["Microsoft-PrometheusMetrics"]
    }
  }
}

resource "azurerm_monitor_data_collection_rule_association" "this" {
  depends_on = [
    azurerm_monitor_data_collection_rule.azuremonitor,
    azapi_resource.aks
  ]
  name                    = "${local.resource_name}-ama-datacollection-rules-association"
  target_resource_id      = azapi_resource.aks.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.azuremonitor.id
}
