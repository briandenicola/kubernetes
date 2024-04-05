module "cluster" {
  source               = "../module"
  region               = var.region
  authorized_ip_ranges = local.authorized_ip_ranges
  resource_name        = local.resource_name
  public_key_openssh   = tls_private_key.rsa.public_key_openssh
  tags                 = var.tags
  kubernetes_version   = "1.28"
  sdlc_environment     = "dev"
  vm_sku               = var.vm_size
  vm_os                = "Ubuntu"
  node_count           = var.node_count
  enable_mesh          = false
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  depends_on = [
    data.azurerm_kubernetes_cluster.this
  ]
  name                  = "kata"
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.this.id
  node_count            = var.node_count
  os_sku                = "AzureLinux"
  vm_size               = var.vm_size
  enable_auto_scaling   = true
  min_count             = 1
  max_count             = var.node_count
  max_pods              = 250
  workload_runtime      = "KataMshvVmIsolation"
  os_disk_size_gb       = 127
  vnet_subnet_id        = data.azurerm_kubernetes_cluster.this.agent_pool_profile.0.vnet_subnet_id 
}


