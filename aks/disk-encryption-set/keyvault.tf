resource "azurerm_key_vault" "this" {
  name                          = local.key_vault_name
  resource_group_name           = azurerm_resource_group.this["aks"].name
  location                      = azurerm_resource_group.this["aks"].location
  sku_name                      = "standard"
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  enabled_for_disk_encryption   = true
  purge_protection_enabled      = true
  public_network_access_enabled = true

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"

    ip_rules = ["${chomp(data.http.myip.response_body)}/32"]
  }
}

resource "azurerm_key_vault_access_policy" "az_resource_creator" {
  key_vault_id = azurerm_key_vault.this.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign",
    "GetRotationPolicy",
  ]
}

resource "azurerm_private_endpoint" "key_vault" {
  depends_on = [
    azurerm_key_vault_access_policy.disk_encryption_set_access_policy,
  ]

  name                = "${local.key_vault_name}-endpoint"
  resource_group_name = azurerm_resource_group.this["aks"].name
  location            = azurerm_resource_group.this["aks"].location
  subnet_id           = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "${local.key_vault_name}-endpoint"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.privatelink_vaultcore_azure_net.name
    private_dns_zone_ids = [azurerm_private_dns_zone.privatelink_vaultcore_azure_net.id]
  }
}
