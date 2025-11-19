resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "Azure Red Hat OpenShift; Azure Virtual Network; User Assigned Identities"
    DeployedOn  = timestamp()
  }
}

resource "azurerm_resource_group" "managed_aro_rg" {
  name     = local.aro_managed_resource_group
  location = local.location

  tags = {
    Application = var.tags
    Components  = "Azure Red Hat OpenShift components"
    DeployedOn  = timestamp()
  }
}
