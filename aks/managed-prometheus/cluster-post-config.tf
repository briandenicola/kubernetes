resource "azapi_update_resource" "cluster_updates" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  type        = "Microsoft.ContainerService/managedClusters@2023-01-02-preview"
  resource_id = azurerm_kubernetes_cluster.this.id

  body = jsonencode({
    properties = {
      autoUpgradeProfile = {
        nodeOSUpgradeChannel = "NodeImage"
      }
      azureMonitorProfile = {
        metrics = {
          enabled = true,
          kubeStateMetrics =  {
            metricLabelsAllowlist = ""
            metricAnnotationsAllowList = ""
          }
        }
      }  
    }
  })
}