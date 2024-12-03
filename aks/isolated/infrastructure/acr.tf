resource "azurerm_container_registry" "this" {
  name                     = local.acr_account_name
  resource_group_name      = azurerm_resource_group.this["aks"].name
  location                 = azurerm_resource_group.this["aks"].location
  sku                      = "Premium"
  admin_enabled            = false
  data_endpoint_enabled    = true 
  anonymous_pull_enabled   = true

  network_rule_set {
    default_action = "Deny"
  }
}

resource "azurerm_container_registry_cache_rule" "mcr_cache_rule" {
  name                  = "mrc-cache-rule"
  container_registry_id = azurerm_container_registry.this.id
  target_repo           = "*"
  source_repo           = "mcr.microsoft.com/*"
}

resource "azurerm_private_endpoint" "acr_account" {
  name                = "${local.acr_account_name}-endpoint"
  resource_group_name = azurerm_resource_group.this["aks"].name
  location            = azurerm_resource_group.this["aks"].location
  subnet_id           = azurerm_subnet.private-endpoints.id

  private_service_connection {
    name                           = "${local.acr_account_name}-endpoint"
    private_connection_resource_id = azurerm_container_registry.this.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.privatelink_azurecr_io.name
    private_dns_zone_ids = [azurerm_private_dns_zone.privatelink_azurecr_io.id]
  }
}
