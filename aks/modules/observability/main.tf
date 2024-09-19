data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

locals {
  location             = var.region
  monitor_rg_name      = "${var.resource_name}-monitor-rg"
  grafana_name         = "${var.resource_name}-grafana"
  prometheus_name      = "${var.resource_name}-prometheus"
}

resource "azurerm_resource_group" "this" {
  name     = "${local.monitor_rg_name}"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "Azure Monitor; Prometheus; Grafana"
    Environment = var.sdlc_environment
    DeployedOn  = timestamp()
  }
}
