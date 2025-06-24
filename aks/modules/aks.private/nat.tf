resource "azurerm_public_ip" "this" {
  name                = "${local.nat_name}-pip"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip_prefix" "this" {
  name                = "${local.nat_name}-pip-prefix"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  prefix_length       = 30
}

resource "azurerm_nat_gateway" "this" {
  name                    = local.nat_name
  location                = azurerm_resource_group.this.location
  resource_group_name     = azurerm_resource_group.this.name
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

resource "azurerm_subnet_nat_gateway_association" "this" {
  subnet_id      = azurerm_subnet.compute.id  
  nat_gateway_id = azurerm_nat_gateway.this.id
}

resource "azurerm_subnet_nat_gateway_association" "nodes" {
  subnet_id      = azurerm_subnet.nodes.id  
  nat_gateway_id = azurerm_nat_gateway.this.id
}

resource "azurerm_subnet_nat_gateway_association" "pe" {
  subnet_id      = azurerm_subnet.pe.id  
  nat_gateway_id = azurerm_nat_gateway.this.id
}