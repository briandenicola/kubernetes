resource "azurerm_kubernetes_cluster_node_pool" "app_node_pool" {
  depends_on = [
    data.azurerm_kubernetes_cluster.this
  ]

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  name                  = "apps"
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.this.id
  vnet_subnet_id        = data.azurerm_kubernetes_cluster.this.agent_pool_profile.0.vnet_subnet_id
  vm_size               = var.vm_size
  auto_scaling_enabled  = true
  mode                  = "User"
  os_sku                = local.os_sku
  os_disk_size_gb       = 127
  max_pods              = 250
  node_count            = var.node_count
  min_count             = var.node_count
  max_count             = var.node_count + 2
  
  upgrade_settings {
    max_surge = "25%"
  }
}