module "cluster" {
  depends_on = [
    module.azure_monitor
  ]
  source                             = "../modules/aks.v4"
  region                             = var.region
  authorized_ip_ranges               = local.authorized_ip_ranges
  resource_name                      = local.resource_name
  public_key_openssh                 = tls_private_key.rsa.public_key_openssh
  tags                               = var.tags
  kubernetes_version                 = local.k8s_version
  istio_version                      = local.istio_version
  sdlc_environment                   = local.environment_type
  vm_sku                             = var.vm_size
  vm_os                              = local.os_sku
  node_count                         = var.node_count
  enable_mesh                        = true
  only_critical_addons_enabled       = false
  azurerm_log_analytics_workspace_id = module.azure_monitor.LOG_ANALYTICS_WORKSPACE_ID
}
