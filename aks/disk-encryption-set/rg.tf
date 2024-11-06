resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_aks_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "AKS; KeyVault; Disk Encryption Set"
    Environment = local.sdlc_environment
    DeployedOn  = timestamp()
  }
}

resource "azurerm_resource_group" "network" {
  name     = "${local.resource_name}_network_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "Virtual Network; NSG; Azure Bastion; Azure Nat Gateway"
    Environment = local.sdlc_environment
    DeployedOn  = timestamp()
  }
}

resource "azurerm_resource_group" "monitor" {
  name     = "${local.resource_name}_monitor_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "Application Insights; Log Analytics"
    Environment = local.sdlc_environment
    DeployedOn  = timestamp()
  }
}

resource "azurerm_resource_group" "vm" {
  name     = "${local.resource_name}_vm_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "Linux Virtual Machines"
    Environment = local.sdlc_environment
    DeployedOn  = timestamp()
  }
}