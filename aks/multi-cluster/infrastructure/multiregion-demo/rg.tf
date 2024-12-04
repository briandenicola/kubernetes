resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = var.hub_region

  tags = {
    Application = var.tags
    Components  = "Azure Fleet Manager"
    DeployedOn  = timestamp()
  }
}
