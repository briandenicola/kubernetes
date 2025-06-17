resource "azurerm_resource_group" "this" {
  name     = "${local.aks_name}_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "AKS; Virtual Network; NSG"
    Environment = var.sdlc_environment
    DeployedOn  = timestamp()
  }
}
