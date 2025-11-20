
locals {
  location                   = var.region
  resource_name              = "${random_pet.this.id}-${random_id.this.dec}"
  aro_name                   = replace("${local.resource_name}-aro", "-", "")
  fw_name                    = "${local.resource_name}-firewall"
  vnet_cidr                  = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  master_subnet_cidir        = cidrsubnet(local.vnet_cidr, 8, 2)
  worker_subnet_cidir        = cidrsubnet(local.vnet_cidr, 7, 2)
  fw_subnet_cidir            = cidrsubnet(local.vnet_cidr, 8, 250)
  aro_managed_resource_group = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${local.aro_name}-${local.location}_managed_rg"
  main_vm_size               = "Standard_D8s_v3"
  worker_vm_size             = "Standard_D4s_v3"
  worker_os_disk_size_gb     = 128
  vm_node_count              = 3
}

#Normally takes about 35 minutes to create a cluster.
