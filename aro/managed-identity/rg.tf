resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "Azure Red Hat OpenShift; Azure Virtual Network; User Assigned Identities"
    DeployedOn  = timestamp()
  }
}