module "aks_cluster" {
  depends_on                         = [ module.azure_monitor ]
  source                             = "../modules/aks.v4"
  region                             = azurerm_resource_group.this.location
  authorized_ip_ranges               = local.authorized_ip_ranges
  resource_name                      = local.resource_name
  public_key_openssh                 = tls_private_key.rsa.public_key_openssh
  sdlc_environment                   = local.sdlc_environment
  kubernetes_version                 = local.kubernetes_version
  tags                               = local.tags
  enable_mesh                        = false
  vm_sku                             = var.vm_size
  node_count                         = var.node_count
  azurerm_log_analytics_workspace_id = module.azure_monitor.LOG_ANALYTICS_WORKSPACE_ID
}
