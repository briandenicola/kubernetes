
locals {
  location                     = var.region
  tags                         = var.tags
  resource_name                = "${random_pet.this.id}-${random_id.this.dec}"
  aks_name                     = "${local.resource_name}-aks-cluster"
  virtual_network_name         = "${local.resource_name}-vnet"
  vm_name                      = "${local.resource_name}-vm"
  key_vault_name               = "${local.resource_name}-keyvault"
  nsg_name                     = "${local.resource_name}-default-nsg"
  app_insights_name            = "${local.resource_name}-appinsights"
  log_analytics_workspace_name = "${local.resource_name}-logs"
  bastion_name                 = "${local.resource_name}-bastion"
  aks_node_rg_name             = "${local.aks_name}_nodes_rg"
  vnet_cidr                    = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  pe_subnet_cidir              = cidrsubnet(local.vnet_cidr, 8, 1)
  api_subnet_cidir             = cidrsubnet(local.vnet_cidr, 8, 2)
  nodes_subnet_cidir           = cidrsubnet(local.vnet_cidr, 8, 3)
  compute_subnet_cidir         = cidrsubnet(local.vnet_cidr, 8, 10)
  kubernetes_version           = data.azurerm_kubernetes_service_versions.current.versions[length(data.azurerm_kubernetes_service_versions.current.versions) - 1]
  sdlc_environment             = "Dev"
  jump_vm_sku                  = "Standard_B1ms"
  aks_zones                    = var.region == "canadaeast" || var.region == "northcentralus" ? null : var.zones
  jump_vm_zone                 = var.region == "canadaeast" || var.region == "northcentralus" ? null : local.aks_zones[0]
}


