resource "azurerm_data_protection_backup_vault" "this" {
  name                = local.data_protection_vault_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"
  soft_delete         = "Off"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_data_protection_backup_policy_kubernetes_cluster" "this" {
  name                = "Default-PT4H-backup-policy"
  resource_group_name = azurerm_resource_group.this.name
  vault_name          = azurerm_data_protection_backup_vault.this.name

  backup_repeating_time_intervals = ["R/2024-01-01T02:30:00+00:00/PT4H"]
  time_zone                       = "Central Standard Time"

  default_retention_rule {
    life_cycle {
      duration        = "P7D"
      data_store_type = "OperationalStore"
    }
  }
}

resource "azurerm_data_protection_backup_instance_kubernetes_cluster" "this" {
  depends_on = [
    azurerm_kubernetes_cluster_extension.backups,
    azurerm_role_assignment.dvp_role_aks_reader,
    azurerm_role_assignment.dvp_role_rg_contributor,
    azurerm_role_assignment.dvp_role_blob_data_contributor,
    azurerm_role_assignment.dvp_role_snapshot_contributor,
    azurerm_role_assignment.dvp_role_snapshot_operator,
    azurerm_role_assignment.cluster_id_role_contributor,
  ]
  name                         = module.cluster.AKS_CLUSTER_NAME
  location                     = azurerm_resource_group.this.location
  vault_id                     = azurerm_data_protection_backup_vault.this.id
  kubernetes_cluster_id        = data.azurerm_kubernetes_cluster.this.id
  snapshot_resource_group_name = azurerm_resource_group.this.name
  backup_policy_id             = azurerm_data_protection_backup_policy_kubernetes_cluster.this.id

  backup_datasource_parameters {
    cluster_scoped_resources_enabled = true
    volume_snapshot_enabled          = true
  }
}