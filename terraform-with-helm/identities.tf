data "azurerm_user_assigned_identity" "github_actions" {
  name                = local.github_actions_identity_name
  resource_group_name = local.github_actions_identity_resource_group
  provider            = azurerm.core
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "${local.aks_name}-cluster-identity"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_user_assigned_identity" "aks_kubelet_identity" {
  name                = "${local.aks_name}-kubelet-identity"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}