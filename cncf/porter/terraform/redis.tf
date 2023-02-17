resource "azurerm_redis_cache" "this" {
  name                              = local.redis_name
  resource_group_name               = azurerm_resource_group.this.name
  location                          = azurerm_resource_group.this.location
  capacity                          = 0
  family                            = "C"
  sku_name                          = "Standard"
  enable_non_ssl_port               = false
  public_network_access_enabled     = true
  minimum_tls_version               = "1.2"
  redis_version                     = "6"

  redis_configuration {
  }
}

resource "azurerm_redis_firewall_rule" "codespaces" {
  name                = "codespaces"
  redis_cache_name    = azurerm_redis_cache.this.name
  resource_group_name = azurerm_resource_group.this.name
  start_ip            = chomp(data.http.myip.response_body)
  end_ip              = chomp(data.http.myip.response_body)
}

#resource "azurerm_redis_firewall_rule" "aks" {
#  name                = "aks"
#  redis_cache_name    = azurerm_redis_cache.this.name
#  resource_group_name = azurerm_resource_group.this.name
#  start_ip            = data.azurerm_public_ip.aks.ip_address
#  end_ip              = data.azurerm_public_ip.aks.ip_address
#}
