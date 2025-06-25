# module "cluster" {
#   source               = "../modules/aks.v3"
#   region               = local.location
#   authorized_ip_ranges = local.authorized_ip_ranges
#   resource_name        = local.resource_name
#   public_key_openssh   = tls_private_key.rsa.public_key_openssh
#   tags                 = local.tags
#   kubernetes_version   = "1.31"
#   sdlc_environment     = "dev"
#   vm_sku               = var.vm_size
#   vm_os                = "Ubuntu"
#   node_count           = var.node_count
#   node_labels          = { 
#     "acstor.azure.com/io-engine" = "acstor" 
#     "acstor.azure.com/accept-ephemeral-storage" = true
#   }
# }

module "cluster" {
  source                     = "../modules/aks.private"
  region                     = local.location
  resource_name              = local.resource_name
  public_key_openssh         = tls_private_key.rsa.public_key_openssh
  tags                       = var.tags
  kubernetes_version         = "1.32"
  sdlc_environment           = local.sdlc_environment
  vm_os                      = "AzureLinux"
  node_count                 = var.node_count
  zones                      = local.zones
  log_analytics_workspace_id = module.azure_monitor.LOG_ANALYTICS_WORKSPACE_ID
  authorized_ip_ranges       = local.authorized_ip_ranges #for Azure Jumpbox VM NSG Rules
}


resource "azurerm_kubernetes_cluster_node_pool" "acstor" {
  depends_on = [
    module.cluster
  ]

  name                        = "acstor"
  kubernetes_cluster_id       = module.cluster.AKS_CLUSTER_ID
  vm_size                     = var.vm_size
  zones                       = local.zones
  os_disk_size_gb             = 127
  os_sku                      = "AzureLinux"
  auto_scaling_enabled        = true
  min_count                   = 1
  max_count                   = var.node_count * 2
  node_count                  = var.node_count
  temporary_name_for_rotation = "acsrotation"

  node_labels = {
    "acstor.azure.com/io-engine"                = "acstor"
    "acstor.azure.com/accept-ephemeral-storage" = true
  }
}
