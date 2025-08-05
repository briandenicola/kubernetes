resource "azurerm_public_ip" "this" {
  name                = "${local.nat_name}-pip"
  location            = azurerm_resource_group.this["network"].location
  resource_group_name = azurerm_resource_group.this["network"].name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip_prefix" "this" {
  name                = "${local.nat_name}-pip-prefix"
  location            = azurerm_resource_group.this["network"].location
  resource_group_name = azurerm_resource_group.this["network"].name
  prefix_length       = 30
}

resource "azurerm_nat_gateway" "this" {
  name                    = local.nat_name
  location                = azurerm_resource_group.this["network"].location
  resource_group_name     = azurerm_resource_group.this["network"].name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.this.id
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "this" {
  nat_gateway_id      = azurerm_nat_gateway.this.id
  public_ip_prefix_id = azurerm_public_ip_prefix.this.id
}

resource "azurerm_subnet_nat_gateway_association" "compute" {
  subnet_id      = azurerm_subnet.compute.id  
  nat_gateway_id = azurerm_nat_gateway.this.id
}