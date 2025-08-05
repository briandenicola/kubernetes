
resource "azurerm_resource_group" "aks" {
  name     = "${local.resource_name}_aks_rg"
  location = local.location

  tags = {
    Application = var.tags
    AppName     = local.resource_name
    Components  = "AKS Automatic; Virtual Network; User Assigned Identity; Subnets; Network Security Group"
    DeployedOn  = timestamp()
  }
}



resource "azurerm_resource_group" "monitoring" {
  name     = "${local.resource_name}_monitoring_rg"
  location = local.location

  tags = {
    Application = var.tags
    AppName     = local.resource_name
    Components  = "Log Analytics; Managed Prometheus; Azure Monitor; Azure Grafana"
    DeployedOn  = timestamp()
  }
}
