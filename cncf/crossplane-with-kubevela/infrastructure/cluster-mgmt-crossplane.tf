resource "kubernetes_namespace" "controlplane-system" {
  depends_on = [
    azurerm_kubernetes_cluster.controlplane
  ]
  metadata {
    name = "crossplane-system"
  }
}

resource "kubernetes_secret" "crossplane-azure-secret" {
  metadata {
    name      = "azure-creds"
    namespace = "crossplane-system"
  }

  data = {
    "creds.json" = jsonencode({
        "appId": azuread_application.crossplane.application_id
        "displayName": azuread_service_principal.crossplane.display_name
        "password": azuread_service_principal_password.crossplane.value
        "tenant": azuread_service_principal.crossplane.application_tenant_id
    })
  }

  type = "Opaque"
}