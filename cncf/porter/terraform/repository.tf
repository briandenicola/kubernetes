
resource "azurerm_container_registry" "this" {
  name                     = local.acr_name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  sku                      = "Premium"
  admin_enabled            = false
  data_endpoint_enabled    = true 

  network_rule_set {
    default_action = "Deny"
    ip_rule {
      action   = "Allow"
      ip_range = "${chomp(data.http.myip.response_body)}"
    }
    ip_rule {
      action   = "Allow"
      ip_range = data.azurerm_public_ip.aks.ip_address
    }
  }
}