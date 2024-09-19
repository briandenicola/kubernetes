module "cluster" {
  source               = "../modules/aks.v3"
  region               = var.region
  resource_name        = local.resource_name
  public_key_openssh   = tls_private_key.rsa.public_key_openssh
  tags                 = var.tags
  kubernetes_version   = "1.28"
  sdlc_environment     = "dev"
  vm_sku               = var.vm_size
  vm_os                = "Ubuntu"
  node_count           = var.node_count
  enable_mesh          = false
}