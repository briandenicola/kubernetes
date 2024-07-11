resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

locals {
  location                    = var.region
  resource_name               = "${random_pet.this.id}-${random_id.this.dec}"
  aks_name                    = "${local.resource_name}-aks"
  azuremonitor_workspace_name = "${local.resource_name}-prometheus"
  }

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