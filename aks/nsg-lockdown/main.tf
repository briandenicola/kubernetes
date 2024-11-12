locals {
  location                     = var.region
  tags                         = var.tags
  non_az_regions               = ["northcentralus", "canadaeast", "westcentralus", "westus"]
  resource_name                = "${random_pet.this.id}-${random_id.this.dec}"
  sdlc_environment             = "Dev"

  aks_name                     = "${local.resource_name}-aks"
  virtual_network_name         = "${local.resource_name}-vnet"
  key_vault_name               = "${local.resource_name}-kv"
  vm_name                      = "${local.resource_name}-vm"
  nsg_default_name             = "${local.resource_name}-default-nsg"
  nsg_lockdown_name            = "${local.resource_name}-lockdown-nsg"
  app_insights_name            = "${local.resource_name}-appinsights"
  log_analytics_workspace_name = "${local.resource_name}-logs"
  bastion_name                 = "${local.resource_name}-bastion"
  firewall_name                = "${local.resource_name}-firewall"
  routetable_name              = "${local.resource_name}-routetable"
  aks_node_rg_name             = "${local.aks_name}_nodes_rg"

  vnet_cidr                    = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  fw_subnet_cidr               = cidrsubnet(local.vnet_cidr, 8, 0)
  bastion_subnet_cidir         = cidrsubnet(local.vnet_cidr, 8, 1)
  pe_subnet_cidir              = cidrsubnet(local.vnet_cidr, 8, 2)
  api_subnet_cidir             = cidrsubnet(local.vnet_cidr, 8, 3)
  nodes_subnet_cidir           = cidrsubnet(local.vnet_cidr, 8, 4)
  compute_subnet_cidir         = cidrsubnet(local.vnet_cidr, 8, 10)

  kubernetes_version           = data.azurerm_kubernetes_service_versions.current.versions[length(data.azurerm_kubernetes_service_versions.current.versions) - 1]
  istio_version                = "asm-1-23"
  dns_service_ip               = "100.${random_integer.services_cidr.result}.0.10"
  services_cidr                = "100.${random_integer.services_cidr.result}.0.0/16"
  pod_cidr                     = "100.${random_integer.pod_cidr.result}.0.0/16"
  aks_zones                    = contains(local.non_az_regions, local.location) ? null : var.zones

  jump_vm_sku  = "Standard_B1ms"
  jump_vm_zone = contains(local.non_az_regions, local.location) ? null : random_integer.vm_zone.result
}


