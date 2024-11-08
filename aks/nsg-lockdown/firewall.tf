resource "azurerm_public_ip" "this" {
  name                = "${local.firewall_name}-pip"
  resource_group_name = azurerm_resource_group.this["network"].name
  location            = azurerm_resource_group.this["network"].location
  allocation_method   = "Static"
  sku                 = "Standard" 
}

resource azurerm_firewall this {
  name                = local.firewall_name
  resource_group_name = azurerm_resource_group.this["network"].name
  location            = azurerm_resource_group.this["network"].location
  firewall_policy_id  = azurerm_firewall_policy.this.id
  sku_tier            = "Standard"
  sku_name            = "AZFW_VNet"

  ip_configuration {
    name                 = "standard"
    subnet_id            = azurerm_subnet.AzureFirewall.id
    public_ip_address_id = azurerm_public_ip.this.id
  }
}