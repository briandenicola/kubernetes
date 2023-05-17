resource "azurerm_proximity_placement_group" "zone1" {
  name                = "${local.aks_name}-nodepool1-zone1"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = {
    AZone = "Zone1"
  }
}

resource "azurerm_proximity_placement_group" "zone2" {
  name                = "${local.aks_name}-nodepool2-zone2"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = {
    AZone = "Zone2"
  }
}