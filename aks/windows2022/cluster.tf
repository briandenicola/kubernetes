module "aks_cluster" {
  source               = "../module-v4"
  region               = var.region
  authorized_ip_ranges = local.authorized_ip_ranges
  resource_name        = local.resource_name
  public_key_openssh   = tls_private_key.rsa.public_key_openssh
  tags                 = var.tags
  kubernetes_version   = "1.29"
  sdlc_environment     = "dev"
  vm_sku               = var.vm_size
  vm_os                = "AzureLinux"
  node_count           = var.node_count
  enable_mesh          = false
}