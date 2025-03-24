resource "azurerm_private_dns_zone" "containerapps" {
  name                = data.azurerm_container_app_environment.this.default_domain
  resource_group_name = azurerm_resource_group.this["network"].name
}

resource "azurerm_private_dns_a_record" "containerapps" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.containerapps.name
  resource_group_name = azurerm_resource_group.this["network"].name
  ttl                 = 300
  records             = [ 
    data.azurerm_container_app_environment.this.static_ip_address
  ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "${local.resource_name}-link"
  resource_group_name   = azurerm_resource_group.this["network"].name
  private_dns_zone_name = azurerm_private_dns_zone.containerapps.name
  virtual_network_id    = azurerm_virtual_network.this.id
}