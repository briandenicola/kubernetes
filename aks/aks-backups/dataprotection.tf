resource "azurerm_data_protection_backup_vault" "this" {
  name                = local.data_protection_vault_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

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
