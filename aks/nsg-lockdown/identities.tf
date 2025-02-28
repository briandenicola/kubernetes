resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "${local.aks_name}-cluster-identity"
  resource_group_name = azurerm_resource_group.this["aks"].name
  location            = azurerm_resource_group.this["aks"].location
}

resource "azurerm_user_assigned_identity" "aks_kubelet_identity" {
  name                = "${local.aks_name}-kubelet-identity"
  resource_group_name = azurerm_resource_group.this["aks"].name
  location            = azurerm_resource_group.this["aks"].location
}
