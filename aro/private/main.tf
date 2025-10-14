
locals {
  location                   = var.region
  resource_name              = "${random_pet.this.id}-${random_id.this.dec}"
  aro_name                   = replace("${local.resource_name}-aro", "-", "")
  aro_version                = "4.16.48" #the latest version as of 2025. `az aro get-versions --location canadaeast`
  vnet_cidr                  = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  master_subnet_cidir        = cidrsubnet(local.vnet_cidr, 8, 2)
  worker_subnet_cidir        = cidrsubnet(local.vnet_cidr, 7, 2)
  aro_managed_resource_group = "${local.resource_name}-aro-${local.location}_rg"
  main_vm_size               = "Standard_D8s_v3"
  worker_vm_size             = "Standard_D4s_v3"
  worker_os_disk_size_gb     = 128
  vm_node_count              = 3
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "Azure Red Hat OpenShift"
    DeployedOn  = timestamp()
  }
}
