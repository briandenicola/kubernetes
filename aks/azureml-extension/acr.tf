resource "azurerm_container_registry" "this" {
  name                     = local.acr_name
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = local.location
  sku                      = "Premium"
  admin_enabled            = false

  network_rule_set {
    default_action = "Deny"
    ip_rule {
      action              = "Allow"
      ip_range            =  "${local.ip_address}/32"
    }
  }
  
}

resource "azurerm_private_endpoint" "acr" {
  name                      = "ple-${local.acr_name}"
  resource_group_name       = data.azurerm_resource_group.this.name
  location                  = local.location
  subnet_id                 = data.azurerm_subnet.pe.id

  private_service_connection {
    name                           = "psc-${local.resource_name}"
    private_connection_resource_id = azurerm_container_registry.this.id
    subresource_names              = [ "registry" ]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                          = azurerm_private_dns_zone.acr.name
    private_dns_zone_ids          = [ azurerm_private_dns_zone.acr.id ]
  }
}