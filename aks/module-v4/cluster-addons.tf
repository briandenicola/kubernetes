resource "azapi_update_resource" "cluster_updates" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  type        = "Microsoft.ContainerService/managedClusters@2024-03-02-preview"
  resource_id = azurerm_kubernetes_cluster.this.id

  body = jsonencode({
    properties = {
      networkProfile = {
        advancedNetworking = {
          observability = {
            enabled = true
          }
        }
      }
    }
  })
}