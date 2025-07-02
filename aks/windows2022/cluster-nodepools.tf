resource "azurerm_kubernetes_cluster_node_pool" "windows_node_pool" {
  depends_on = [
    data.azurerm_kubernetes_cluster.this
  ]

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  name                  = "wp2k02"
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.this.id
  vnet_subnet_id        = data.azurerm_kubernetes_cluster.this.agent_pool_profile.0.vnet_subnet_id
  vm_size               = var.vm_size
  auto_scaling_enabled  = true
  mode                  = "User"
  os_type               = "Windows"
  os_sku                = "Windows2022"
  os_disk_size_gb       = 127
  max_pods              = 250
  node_count            = var.node_count
  min_count             = var.node_count
  max_count             = var.node_count + 2
  zones                 = local.zones

  node_taints = ["role=applications:NoSchedule"]
}
