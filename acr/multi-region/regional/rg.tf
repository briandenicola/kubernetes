resource "azurerm_resource_group" "regional_rg" {
  name     = local.apps_rg_name
  location = var.location
  tags = {
    Application = var.tags
    AppName     = var.app_name
    Components  = "Azure Virtual Network, Azure Container Registry"
    DeployedOn  = timestamp()
  }
}
