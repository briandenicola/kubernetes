resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = var.region

  tags = {
    Application = var.tags
    Components  = "Fleet Manager"
    DeployedOn  = timestamp()
  }
}
