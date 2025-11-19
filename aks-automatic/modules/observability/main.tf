data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

locals {
  location             = var.region
  monitor_rg_name      = "${var.resource_name}-monitor_rg"
  grafana_name         = "${var.resource_name}-grafana"
  prometheus_name      = "${var.resource_name}-prometheus"
  streams = [
    "Microsoft-ContainerLog",
    "Microsoft-ContainerLogV2",
    "Microsoft-KubeEvents",
    "Microsoft-KubePodInventory",
    "Microsoft-KubeNodeInventory",
    "Microsoft-KubePVInventory",
    "Microsoft-KubeServices",
    "Microsoft-KubeMonAgentEvents",
    "Microsoft-InsightsMetrics",
    "Microsoft-ContainerInventory",
    "Microsoft-ContainerNodeInventory",
    "Microsoft-Perf"
  ]  
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
