resource "azurerm_user_assigned_identity" "aks_pod_identity" {
  name                = local.workload-identity
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_federated_identity_credential" "aks_pod_identity" {
  name                = local.workload-identity
  resource_group_name = azurerm_resource_group.this.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azurerm_kubernetes_cluster.this.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.aks_pod_identity.id
  subject             = "system:serviceaccount:${var.namespace}:${local.workload-identity}"
}