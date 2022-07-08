/*resource "azurerm_kubernetes_cluster_node_pool" "windows2019_node_pool" {
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
  name                  = "wpl01"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = "Standard_B4ms"
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Windows"
  node_count            = 3
  min_count             = 3
  max_count             = 6
  vnet_subnet_id        = azurerm_subnet.windows.id
  scale_down_mode       = "Deallocate"

  node_taints           = [ "role=applications:NoSchedule" ]
}*/


resource "azapi_resource" "windows2022_node_pool" {
  type        = "Microsoft.ContainerService/managedClusters/agentPools@2022-01-02-preview"
  parent_id   = azurerm_kubernetes_cluster.this.id
  name        = "wnp002"

  body = jsonencode({
    properties = {
      count                   = 3
      vmSize                  = "Standard_B4ms"
      vnetSubnetID            = azurerm_subnet.windows.id
      osDiskSizeGB            = 128
      osDiskType              = "Managed"
      kubeletDiskType         = "OS"
      workloadRuntime         = "OCIContainer"
      orchestratorVersion     = element(local.supported_versions, length(local.supported_versions) - 2)
      enableAutoScaling       = true
      mode                    = "User"
      osType                  = "Windows"
      osSKU                   = "Windows2022"
      scaleDownMode           = "Delete"
      minCount                = 3
      maxCount                = 6
      scaleSetEvictionPolicy  = "Delete"
      nodeTaints              = [ "role=applications:NoSchedule" ]
    }
  })
}
