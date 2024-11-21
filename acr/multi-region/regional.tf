module "regional_resources" {
  depends_on           = [azurerm_container_registry.this]
  for_each             = toset(var.regions)
  source               = "./regional"
  location             = each.value
  primary_location     = element(var.regions, 0)
  app_name             = local.resource_name
  authorized_ip_ranges = local.authorized_ip_ranges
  tags                 = var.tags
}
