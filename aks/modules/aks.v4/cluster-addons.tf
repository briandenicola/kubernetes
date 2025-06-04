resource "azapi_update_resource" "cluster_updates" {
  count = var.enable_addons ? 1 : 0
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  type        = "Microsoft.ContainerService/managedClusters@2024-07-02-preview"
  resource_id = azurerm_kubernetes_cluster.this.id

  body = {
    properties = {
      agentPoolProfiles = [{
       name = "system"
       upgradeSettings = {
         undrainableNodeBehavior = "Cordon"
      }
      }]
      networkProfile = {
        advancedNetworking = {
          enabled = true,
          observability = {
            enabled = true
          }
          security = {
            enable = true
          }          
        }
      }
    }
  }
}