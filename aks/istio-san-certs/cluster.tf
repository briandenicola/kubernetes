module "cluster" {
  source               = "../module"
  region               = var.region
  zones                = var.zones
  authorized_ip_ranges = local.authorized_ip_ranges
  resource_name        = local.resource_name
  public_key_openssh   = tls_private_key.rsa.public_key_openssh
  tags                 = var.tags
  kubernetes_version   = "1.29"
  sdlc_environment     = "dev"
  vm_sku               = var.vm_size
  node_count           = var.node_count
  enable_mesh          = false 
}
