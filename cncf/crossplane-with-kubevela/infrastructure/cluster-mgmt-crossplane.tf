resource "kubernetes_namespace" "controlplane-system" {
  depends_on = [
    azurerm_kubernetes_cluster.controlplane
  ]
  metadata {
    name = "upbound-system"
  }
}

resource "kubernetes_secret" "crossplane-azure-secret" {
  depends_on = [
    kubernetes_namespace.controlplane-system
  ]

  metadata {
    name      = "azure-creds"
    namespace = "upbound-system"
  }

  data = {
    "creds" = jsonencode({
      "clientId": azuread_application.crossplane.application_id
      "clientSecret": azuread_service_principal_password.crossplane.value
      "tenantId": data.azurerm_client_config.current.tenant_id
      "subscriptionId": data.azurerm_client_config.current.subscription_id 
      "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
      "resourceManagerEndpointUrl": "https://management.azure.com/",
      "activeDirectoryGraphResourceId": "https://graph.windows.net/",
      "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
      "galleryEndpointUrl": "https://gallery.azure.com/",
      "managementEndpointUrl": "https://management.core.windows.net/"
    })
  }

  type = "Opaque"
}