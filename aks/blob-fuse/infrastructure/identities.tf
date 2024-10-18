resource "azurerm_user_assigned_identity" "app_identity" {
  name                = local.workload_identity
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_federated_identity_credential" "aks_pod_identity" {
  depends_on = [ 
    module.aks_cluster
  ]

  name                = local.workload_identity
  resource_group_name = azurerm_resource_group.this.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks_cluster.AKS_OIDC_ISSUER_URL
  parent_id           = azurerm_user_assigned_identity.app_identity.id
  subject             = "system:serviceaccount:${var.namespace}:${local.workload_identity}"
}