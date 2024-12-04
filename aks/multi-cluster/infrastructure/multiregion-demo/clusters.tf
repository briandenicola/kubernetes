module "cluster_resources" {
  for_each              = toset(var.regions)
  source                = "../cluster"
  region                = each.value
  authorized_ip_ranges  = local.authorized_ip_ranges
  resource_name         = "${local.resource_name}-${each.value}"
  public_key_openssh    = tls_private_key.rsa.public_key_openssh
  sdlc_environment      = local.sdlc_environment
  kubernetes_version    = local.kubernetes_version
  tags                  = var.tags
}