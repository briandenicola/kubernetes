
resource "azurerm_private_dns_zone" "privatelink_azurecr_io" {
  name                = "privatelink.azurecr.io"
  resource_group_name = local.vnet_rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_azurecr_io" {
  name                  = "${local.vnet_name}-acr-link"
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_azurecr_io.name
  resource_group_name   = local.vnet_rg_name
  virtual_network_id    = var.azurerm_virtual_network_id
}

resource "azurerm_private_dns_zone" "aks_private_zone" {
  name                = "privatelink.${local.location}.azmk8s.io"
  resource_group_name = local.vnet_rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_private_zone" {
  name                  = "${local.vnet_name}-link"
  private_dns_zone_name = azurerm_private_dns_zone.aks_private_zone.name
  resource_group_name   = local.vnet_rg_name
  virtual_network_id    = var.azurerm_virtual_network_id
}

resource "azurerm_private_dns_zone" "privatelink_vaultcore_azure_net" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = local.vnet_rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_vaultcore_azure_net" {
  name                  = "${local.vnet_name}-link"
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_vaultcore_azure_net.name
  resource_group_name   = local.vnet_rg_name
  virtual_network_id    = var.azurerm_virtual_network_id
}
