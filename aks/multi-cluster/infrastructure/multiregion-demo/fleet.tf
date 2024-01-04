resource "azurerm_kubernetes_fleet_manager" "this" {
   location            = azurerm_resource_group.this.location
   name                = local.fleet_name
   resource_group_name = azurerm_resource_group.this.name

   hub_profile {
     dns_prefix = local.resource_name
   }
 }

resource "azapi_resource" "fleet_members" {
  depends_on = [
    azurerm_kubernetes_fleet_manager.this,
    module.cluster_resources
  ]

  for_each  = toset(var.regions)
  type      = "Microsoft.ContainerService/fleets/members@2023-06-15-preview"
  name      = "${module.cluster_resources[each.key].AKS_CLUSTER_NAME}-member"
  parent_id = azurerm_kubernetes_fleet_manager.this.id
  body = jsonencode({
    properties = {
      clusterResourceId = module.cluster_resources[each.key].AKS_CLUSTER_ID
      group             = each.key
    }
  })
}
