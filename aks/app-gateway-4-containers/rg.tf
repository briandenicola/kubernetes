data "azurerm_resource_group" "this" {
  depends_on = [
    module.azure_monitor,
    module.cluster
  ]
  name = module.cluster.AKS_RESOURCE_GROUP
}
