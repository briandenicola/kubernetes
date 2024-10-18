resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = var.region

  tags = {
    Application = local.tags
    Components  = "AKS; Storage; Workload Identity"
    DeployedOn  = timestamp()
  }
}