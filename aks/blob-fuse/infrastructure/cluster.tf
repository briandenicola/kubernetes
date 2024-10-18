module "aks_cluster" {
  depends_on = [
    module.azure_monitor
  ]

  source                             = "../../modules/aks.v4"
  region                             = var.region
  zones                              = ["1"]
  authorized_ip_ranges               = local.authorized_ip_ranges
  resource_name                      = local.resource_name
  public_key_openssh                 = tls_private_key.rsa.public_key_openssh
  tags                               = local.tags
  kubernetes_version                 = local.k8s_version
  sdlc_environment                   = local.environment_type
  enable_csi_drivers                 = true
  enable_mesh                        = false
  azurerm_log_analytics_workspace_id = module.azure_monitor.LOG_ANALYTICS_WORKSPACE_ID
}