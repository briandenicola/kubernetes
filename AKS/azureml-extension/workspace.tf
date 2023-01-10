resource "azurerm_machine_learning_workspace" "this" {
    name                            = "${local.resource_name}-amlworkspace"
    location                        = azurerm_resource_group.this.location
    resource_group_name             = azurerm_resource_group.this.name
    application_insights_id         = azurerm_application_insights.this.id
    key_vault_id                    = azurerm_key_vault.this.id
    storage_account_id              = azurerm_storage_account.this.id
    container_registry_id           = azurerm_container_registry.this.id
    public_network_access_enabled   = true

    identity {
        type = "SystemAssigned"
    }
}

resource "azurerm_private_endpoint" "mlw" {
  name                = "ple-${local.resource_name}-amlworkspace"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.pe.id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.azureml.id, azurerm_private_dns_zone.notebooks.id]
  }

  private_service_connection {
    name                           = "psc-${local.resource_name}"
    private_connection_resource_id = azurerm_machine_learning_workspace.this.id
    subresource_names              = ["amlworkspace"]
    is_manual_connection           = false
  }
}