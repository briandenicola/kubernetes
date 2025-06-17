module "aks" {
  source = "../modules/aks.azapi"

  region           = var.region
  resource_name    = local.resource_name
  tags             = var.tags
  sdlc_environment = local.environment_type

  aks_cluster = {
    name               = "${local.resource_name}-aks"
    kubernetes_version = local.kubernetes_version
    zones              = ["1", "2", "3"]
    allowed_ip_ranges  = local.authorized_ip_ranges
    public_key_openssh = tls_private_key.rsa.public_key_openssh
    istio = {
      enabled = false
      version = null
    }
    nodes = {
      sku   = var.vm_size
      count = var.node_count
    }
    logs = {
      workspace_id = module.azure_monitor.LOG_ANALYTICS_WORKSPACE_ID
    }
  }
}
