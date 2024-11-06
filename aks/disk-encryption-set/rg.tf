resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "AKS; Virtual Network; NSG; KeyVault; Disk Encryption Set"
    Environment = local.sdlc_environment
    DeployedOn  = timestamp()
  }
}