
locals {
  location                     = var.region
  tags                         = var.tags
  non_az_regions               = ["northcentralus", "canadaeast", "westcentralus", "westus"]
  aks_name                     = "${var.resource_name}-aks"
  acr_account_name             = "${replace(var.resource_name, "-", "")}acr"
  virtual_network_name         = "${var.resource_name}-vnet"
  key_vault_name               = "${var.resource_name}-keyvault"
  nsg_name                     = "${var.resource_name}-default-nsg"
  aks_node_rg_name             = "${local.aks_name}_nodes_rg"
  kubernetes_version           = data.azurerm_kubernetes_service_versions.current.versions[length(data.azurerm_kubernetes_service_versions.current.versions) - 1]
}

resource "azurerm_resource_group" "this" {
  name     = "${local.aks_name}_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "AKS; Virtual Network; NSG"
    Environment = var.sdlc_environment
    DeployedOn  = timestamp()
  }
}