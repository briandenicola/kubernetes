resource "azurerm_user_assigned_identity" "app_identity" {
  depends_on = [
    module.azure_monitor,
    module.aks_cluster
  ]
  name                = local.app_identity_name
  location            = local.location
  resource_group_name = module.aks_cluster.AKS_RESOURCE_GROUP
}

resource "azurerm_federated_identity_credential" "app_identity" {
  name                = "azure-app-identity"
  resource_group_name = module.aks_cluster.AKS_RESOURCE_GROUP
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks_cluster.AKS_OIDC_ISSUER_URL
  parent_id           = azurerm_user_assigned_identity.app_identity.id
  subject             = "system:serviceaccount:${local.namespace}:${local.app_identity_name}"
}                                                                                                 