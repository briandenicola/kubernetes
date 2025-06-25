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
  vm_size                    = var.vm_size
  vm_os                      = "AzureLinux"
  node_count                 = var.node_count
  zones                      = local.zones
  log_analytics_workspace_id = module.azure_monitor.LOG_ANALYTICS_WORKSPACE_ID
  node_labels = {
    "acstor.azure.com/io-engine"                = "acstor"
    "acstor.azure.com/accept-ephemeral-storage" = true
  }
}
