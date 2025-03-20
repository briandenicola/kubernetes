resource "azurerm_user_assigned_identity" "alb_identity" {
  depends_on = [
    module.azure_monitor,
    module.cluster
  ]
  name                = local.alb_identity_name
  location            = local.location
  resource_group_name = module.cluster.AKS_RESOURCE_GROUP
}

resource "azurerm_federated_identity_credential" "alb_identity" {
  name                = "azure-alb-identity"
  resource_group_name = module.cluster.AKS_RESOURCE_GROUP
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.cluster.AKS_OIDC_ISSUER_URL
  parent_id           = azurerm_user_assigned_identity.alb_identity.id
  subject             = "system:serviceaccount:${local.namespace}:${local.alb_identity_name}"
}