resource "azurerm_user_assigned_identity" "aks_service_mesh_identity" {
  name                = local.aks_service_mesh_identity
  resource_group_name = data.azurerm_resource_group.this.name
  location            = local.location
}

resource "azurerm_federated_identity_credential" "aks_service_mesh_identity" {
  name                = "istio-ingress-sa-identity"
  resource_group_name = data.azurerm_resource_group.this.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azurerm_kubernetes_cluster.this.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.aks_service_mesh_identity.id
  subject             = "system:serviceaccount:istio-ingress:istio-ingress-sa-identity"
}