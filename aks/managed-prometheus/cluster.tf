locals {
  authorized_ip_ranges  = "${jsondecode(data.http.myip.response_body).ip}/32"
  kubernetes_version    = data.azurerm_kubernetes_service_versions.current.versions[length(data.azurerm_kubernetes_service_versions.current.versions) - 1]
}

module "aks_cluster" {
  source                = "../module"
  region                = azurerm_resource_group.this.location
  authorized_ip_ranges  = local.authorized_ip_ranges
  resource_name         = local.resource_name
  public_key_openssh    = tls_private_key.rsa.public_key_openssh
  sdlc_environment      = "Production"
  kubernetes_version    = local.kubernetes_version
  tags                  = local.tags
}
