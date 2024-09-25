resource "azurerm_cognitive_account" "this" {
  name                = local.cognitive_services_name
  location            = "northcentralus"
  resource_group_name = azurerm_resource_group.this.name
  kind                = "FormRecognizer"
  sku_name            = "S0"
}
