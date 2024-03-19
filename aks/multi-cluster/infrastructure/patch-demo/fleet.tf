resource "azurerm_kubernetes_fleet_manager" "this" {
  location            = azurerm_resource_group.this.location
  name                = local.fleet_name
  resource_group_name = azurerm_resource_group.this.name

}

resource "azurerm_kubernetes_fleet_member" "this" {
  for_each  = toset(var.sdlc_environments)
  kubernetes_fleet_id   = azurerm_kubernetes_fleet_manager.this.id
  name                  = "${module.cluster_resources[each.key].AKS_CLUSTER_NAME}-member"
  kubernetes_cluster_id = module.cluster_resources[each.key].AKS_CLUSTER_ID
  group                 = each.key

}

resource "azurerm_kubernetes_fleet_update_strategy" "this" {
  name                        = "standard"
  kubernetes_fleet_manager_id = azurerm_kubernetes_fleet_manager.this.id

  dynamic "stage" {
    for_each = toset(var.sdlc_environments)
    content {
      name = stage.key
      group {
        name = stage.key
      }
      after_stage_wait_in_seconds = 600
    }
  }
}