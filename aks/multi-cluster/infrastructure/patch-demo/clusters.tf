module "cluster_resources" {
  for_each                  = toset(var.sdlc_environments)
  source                    = "../cluster"
  region                    = var.region
  authorized_ip_ranges      = local.authorized_ip_ranges
  resource_name             = "${local.resource_name}-${each.value}"
  public_key_openssh        = tls_private_key.rsa.public_key_openssh
  sdlc_environment          = each.value
  kubernetes_version        = "1.29"
  automatic_channel_upgrade = var.automatic_channel_upgrade
  node_os_channel_upgrade   = var.node_os_channel_upgrade
}