module "azure_monitor" {
  source                   = "../modules/observability"
  region                   = var.region
  resource_name            = local.resource_name
  tags                     = var.tags
  sdlc_environment         = local.sdlc_environment
  enable_managed_offerings = false
}

module "aks" {
  depends_on = [
    module.azure_monitor,
    azurerm_nat_gateway.this,
  ]

  source                             = "./aks"
  resource_name                      = local.resource_name
  tags                               = var.tags
  region                             = var.region
  public_key_openssh                 = tls_private_key.rsa.public_key_openssh
  kubernetes_version                 = local.kubernetes_version
  sdlc_environment                   = local.sdlc_environment
  azurerm_log_analytics_workspace_id = module.azure_monitor.LOG_ANALYTICS_WORKSPACE_ID
  azurerm_subnet_nodes_id            = azurerm_subnet.nodes.id
  azurerm_virtual_network_id         = azurerm_virtual_network.this.id
  authorized_ip_ranges               = local.authorized_ip_ranges
}

module "bastion" {
  count  = var.deploy_jumpbox ? 1 : 0
  source = "./bastion"
  bastion_host = {
    location            = azurerm_resource_group.this["network"].location
    name                = local.bastion_name
    resource_group_name = azurerm_resource_group.this["network"].name
    vnet = {
      id = azurerm_virtual_network.this.id
    }
  }
}

module "jumpbox" {
  count  = var.deploy_jumpbox ? 1 : 0
  source = "./jumpbox"
  vm = {
    name                = local.vm_name
    resource_group_name = azurerm_resource_group.this["vm"].name
    location            = azurerm_resource_group.this["vm"].location
    zone                = local.jump_vm_zone
    sku                 = "Standard_B1s"
    admin = {
      username     = "manager"
      ssh_key_path = "~/.ssh/id_rsa.pub"
    }
    vnet = {
      subnet_id = azurerm_subnet.compute.id
    }
  }
}
