resource "azapi_update_resource" "storageclass" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

    type        = "Microsoft.ContainerService/managedClusters@2022-08-01"
    resource_id = azurerm_kubernetes_cluster.this.id

    body = jsonencode({
        properties = {
            storageProfile = {
                diskCSIDriver = {
                    enabled = false
                },
                fileCSIDriver = {
                    enabled = false
                },
                snapshotController = {
                    enabled = false
                }
            }
        }  
    })
}
