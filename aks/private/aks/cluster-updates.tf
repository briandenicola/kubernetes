resource "azapi_update_resource" "vnet_injection" {
  
  type        = "Microsoft.ContainerService/managedClusters@2025-04-01"
  resource_id = azurerm_kubernetes_cluster.this.id

  body = {
    properties = {
      apiServerAccessProfile = {
        enableVnetIntegration = true
        subnetId              = data.azurerm_subnet.api.id
      }
    }
  }
}