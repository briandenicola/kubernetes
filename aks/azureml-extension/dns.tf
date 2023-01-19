resource "azurerm_private_dns_zone" "blob" {
  name                      = "privatelink.blob.core.windows.net"
  resource_group_name       = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                      = "link"
  private_dns_zone_name     = azurerm_private_dns_zone.blob.name
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_id        = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_zone" "file" {
  name                      = "privatelink.file.core.windows.net"
  resource_group_name       = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "file" {
  name                      = "link"
  private_dns_zone_name     = azurerm_private_dns_zone.file.name
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_id        = azurerm_virtual_network.this.id
}


resource "azurerm_private_dns_zone" "vault" {
  name                      = "privatelink.vaultcore.azure.net"
  resource_group_name       = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vault" {
  name                      = "link"
  private_dns_zone_name     = azurerm_private_dns_zone.vault.name
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_id        = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_zone" "acr" {
  name                      = "privatelink.azurecr.io"
  resource_group_name       = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
  name                      = "link"
  private_dns_zone_name     = azurerm_private_dns_zone.acr.name
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_id        = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_zone" "azureml" {
  name                      = "privatelink.api.azureml.ms"
  resource_group_name       = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "azureml" {
  name                      = "link"
  private_dns_zone_name     = azurerm_private_dns_zone.azureml.name
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_id        = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_zone" "notebooks" {
  name                      = "privatelink.notebooks.azure.net"
  resource_group_name       = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "notebooks" {
  name                      = "link"
  private_dns_zone_name     = azurerm_private_dns_zone.notebooks.name
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_id        = azurerm_virtual_network.this.id
}


