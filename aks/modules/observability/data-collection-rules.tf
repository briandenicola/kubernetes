resource "azurerm_monitor_data_collection_rule" "container_insights" {
  depends_on = [
    azurerm_monitor_workspace.this,
    azurerm_monitor_data_collection_endpoint.this
  ]
  count               = var.enable_managed_offerings ? 1 : 0
  name                = "${var.resource_name}-container-insights-rules"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.this.id
      name                  = "ciworkspace"
    }
  }

  data_flow {
    streams      = local.streams
    destinations = ["ciworkspace"]
  }

  data_sources {
    extension {
      streams        = local.streams
      extension_name = "ContainerInsights"
      extension_json = jsonencode({
        "dataCollectionSettings" : {
          "interval" : "1m",
          "namespaceFilteringMode" : "Off",
          "enableContainerLogV2" : true
        }
      })
      name = "ContainerInsightsExtension"
    }
  }
}

resource "azurerm_monitor_data_collection_rule" "azuremonitor" {
  depends_on = [
    azurerm_monitor_workspace.this,
    azurerm_monitor_data_collection_endpoint.this
  ]
  count               = var.enable_managed_offerings ? 1 : 0
  name                        = "${var.resource_name}-ama-datacollection-rules"
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  kind                        = "Linux"
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.this[0].id

  destinations {
    monitor_account {
      monitor_account_id = azurerm_monitor_workspace.this[0].id
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
