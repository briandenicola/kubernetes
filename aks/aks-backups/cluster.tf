module "cluster" {
  source               = "../modules/aks.v4"
  region               = var.region
  authorized_ip_ranges = local.authorized_ip_ranges
  resource_name        = local.resource_name
  public_key_openssh   = tls_private_key.rsa.public_key_openssh
  tags                 = var.tags
  kubernetes_version   = "1.32"
  sdlc_environment     = local.environment_type
  vm_sku               = var.vm_size
  vm_os                = "Ubuntu"
  node_count           = var.node_count
  enable_mesh          = false
  azurerm_log_analytics_workspace_id = module.azure_monitor.LOG_ANALYTICS_WORKSPACE_ID
}

resource "azurerm_kubernetes_cluster_trusted_access_role_binding" "this" {
  depends_on = [
    azurerm_kubernetes_cluster_extension.backups,
  ]
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.this.id
  name                  = "backuprolebinding"
  roles                 = ["Microsoft.DataProtection/backupVaults/backup-operator"]
  source_resource_id    = azurerm_data_protection_backup_vault.this.id
}
