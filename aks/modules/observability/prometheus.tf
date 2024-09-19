resource "azurerm_monitor_workspace" "this" {
  name                = local.prometheus_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_monitor_data_collection_endpoint" "this" {
  name                          = "${var.resource_name}-ama-datacollection-ep"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  kind                          = "Linux"
  public_network_access_enabled = true
}



