# resource "azurerm_kubernetes_fleet_manager" "this" {
#   location            = azurerm_resource_group.this.location
#   name                = local.fleet_name
#   resource_group_name = azurerm_resource_group.this.name

#   hub_profile {
#     dns_prefix = local.resource_name
#   }
# }

#Creating an Update Only Fleet Manager Resource
resource "azapi_resource" "fleet" {
    depends_on = [
        azurerm_resource_group.this,
        azurerm_user_assigned_identity.fleet_identity
    ]
  type      = "Microsoft.ContainerService/fleets@2023-06-15-preview"
  name      = local.fleet_name
  parent_id = azurerm_resource_group.this.id
  location  = var.region

  identity {
    type = "UserAssigned"
    identity_ids = [
        azurerm_user_assigned_identity.fleet_identity.id
    ]
  }

  body = jsonencode({
    properties = {}
  })
}

resource "azapi_resource" "fleet_members" {
  depends_on = [
    azapi_resource.fleet,
    module.cluster_resources
  ]

  for_each  = toset(var.sdlc_environments)
  type      = "Microsoft.ContainerService/fleets/members@2023-06-15-preview"
  name      = "${module.cluster_resources[each.key].AKS_CLUSTER_NAME}-member"
  parent_id = azapi_resource.fleet.id
  body = jsonencode({
    properties = {
      clusterResourceId = module.cluster_resources[each.key].AKS_CLUSTER_ID
      group             = each.key
    }
  })
}
