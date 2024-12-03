resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "${local.aks_name}-cluster-identity"
  resource_group_name = var.aks_cluster.resource_group.name
  location            = var.aks_cluster.location
}

resource "azurerm_user_assigned_identity" "aks_kubelet_identity" {
  name                = "${local.aks_name}-kubelet-identity"
  resource_group_name = var.aks_cluster.resource_group.name
  location            = var.aks_cluster.location

}