resource "azurerm_private_dns_zone" "aks_private_zone" {
  name                = "privatelink.${local.location}.azmk8s.io"
  resource_group_name = var.aks_cluster.resource_group.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_private_zone" {
  name                  = "${var.aks_cluster.name}-link"
  private_dns_zone_name = azurerm_private_dns_zone.aks_private_zone.name
  resource_group_name   = var.aks_cluster.resource_group.name
  virtual_network_id    = var.aks_cluster.vnet.id #aks_vnet_id
}
