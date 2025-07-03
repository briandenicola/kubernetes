module "aks" {
  depends_on = [
    azurerm_container_registry_cache_rule.mcr_cache_rule,
    azurerm_private_endpoint.acr_account
  ]
  source     = "./aks"
  zones      = var.zones
  aks_cluster = {
    name = local.aks_name
    resource_group = {
      name = azurerm_resource_group.this["aks"].name
      id   = azurerm_resource_group.this["aks"].id
    }
    location = azurerm_resource_group.this["aks"].location
    version  = local.kubernetes_version
    istio = {
      version = local.istio_version
    }
    nodes = {
      sku   = var.node_sku
      count = var.node_count
      os    = "Ubuntu"
    }
    vnet = {
      id = azurerm_virtual_network.this.id
      node_subnet = {
        id = azurerm_subnet.nodes.id
      }
      mgmt_subnet = {
        id = azurerm_subnet.api.id
      }
    }
    logs = {
      workspace_id = azurerm_log_analytics_workspace.this.id
    }
    container_registry = {
      id = azurerm_container_registry.this.id
    }
    flux = {
      enabled = var.deploy_flux_extension
    }
  }
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
