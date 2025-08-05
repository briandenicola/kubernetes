
resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = local.location

  tags = {
    Application = var.tags
    AppName     = local.resource_name
    Components  = "AKS Automatic; Log Analytics; Managed Prometheus; Azure Monitor; Azure Grafana"
    DeployedOn  = timestamp()
  }
}
