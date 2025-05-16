module "cluster" {
  source               = "../modules/aks.v3"
  region               = var.region
  authorized_ip_ranges = local.authorized_ip_ranges
  resource_name        = local.resource_name
  public_key_openssh   = tls_private_key.rsa.public_key_openssh
  tags                 = local.tags
  kubernetes_version   = "1.31"
  sdlc_environment     = "dev"
  vm_sku               = var.vm_size
  vm_os                = "Ubuntu"
  node_count           = var.node_count
  node_labels          = { 
    "acstor.azure.com/io-engine" = "acstor" 
    "acstor.azure.com/accept-ephemeral-storage" = true
  }
}