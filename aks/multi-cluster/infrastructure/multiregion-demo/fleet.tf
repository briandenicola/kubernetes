resource "azurerm_kubernetes_fleet_manager" "this" {
  location            = azurerm_resource_group.this.location
  name                = local.fleet_name
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_kubernetes_fleet_member" "this" {
  depends_on = [
    azurerm_kubernetes_fleet_manager.this,
    module.cluster_resources
  ]
  for_each              = toset(var.regions)
  kubernetes_fleet_id   = azurerm_kubernetes_fleet_manager.this.id
  name                  = "${module.cluster_resources[each.key].AKS_CLUSTER_NAME}-member"
  kubernetes_cluster_id = module.cluster_resources[each.key].AKS_CLUSTER_ID
  group                 = each.key
}
