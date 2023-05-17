resource "azurerm_kubernetes_cluster_node_pool" "apps_zone1" {
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
  name                         = "appszone1"
  kubernetes_cluster_id        = azurerm_kubernetes_cluster.this.id
  vm_size                      = var.vm_size
  enable_auto_scaling          = true
  mode                         = "User"
  os_sku                       = "CBLMariner"
  os_disk_size_gb              = 100
  max_count                    = 3
  min_count                    = 1
  node_count                   = var.node_count
  proximity_placement_group_id = azurerm_proximity_placement_group.zone1.id
  kubelet_disk_type            = "Temporary"
  zones                        = ["1"]
  vnet_subnet_id               = azurerm_subnet.nodes.id

  upgrade_settings {
    max_surge = "25%"
  }

  node_taints = ["reservedFor=apps:NoSchedule"]
}

resource "azurerm_kubernetes_cluster_node_pool" "apps_zone2" {
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
  name                         = "appszone2"
  kubernetes_cluster_id        = azurerm_kubernetes_cluster.this.id
  vm_size                      = var.vm_size
  enable_auto_scaling          = true
  mode                         = "User"
  os_sku                       = "CBLMariner"
  os_disk_size_gb              = 100
  max_count                    = 3
  min_count                    = 1
  node_count                   = var.node_count
  proximity_placement_group_id = azurerm_proximity_placement_group.zone2.id
  kubelet_disk_type            = "Temporary"
  zones                        = ["2"]
  vnet_subnet_id               = azurerm_subnet.nodes.id

  upgrade_settings {
    max_surge = "25%"
  }

  node_taints = ["reservedFor=apps:NoSchedule"]
}