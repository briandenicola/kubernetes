
locals {
  location                     = var.region
  tags                         = var.tags
  non_az_regions               = ["northcentralus", "canadaeast", "westcentralus", "westus"]
  aks_name                     = "${var.resource_name}-aks"
  acr_account_name             = "${replace(var.resource_name, "-", "")}acr"
  virtual_network_name         = "${var.resource_name}-vnet"
  nsg_name                     = "${var.resource_name}-default-nsg"
  aks_node_rg_name             = "${local.aks_name}_nodes_rg"
}

resource "azurerm_resource_group" "aks" {
  name     = "${local.aks_name}_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "AKS; Virtual Network; NSG"
    Environment = var.sdlc_environment
    DeployedOn  = timestamp()
  }
}