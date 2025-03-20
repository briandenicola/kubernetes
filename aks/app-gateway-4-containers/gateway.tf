resource "azurerm_application_load_balancer" "this" {
  depends_on = [ 
    module.azure_monitor,
    module.cluster,
    azurerm_role_assignment.alb_identity_network_contributor,
    azurerm_role_assignment.alb_identity_appgw_config_manager
  ]
  name                = local.alb_name
  location            = local.location
  resource_group_name = module.cluster.AKS_RESOURCE_GROUP
}
 
resource "azurerm_application_load_balancer_subnet_association" "this" {
  name                         = "alb-subnet-association"
  application_load_balancer_id = azurerm_application_load_balancer.this.id
  subnet_id                    = module.cluster.ALB_SUBNET_ID
}
 
resource "azurerm_application_load_balancer_frontend" "this" {
  name                         = "${local.alb_name}-frontend"
  application_load_balancer_id = azurerm_application_load_balancer.this.id
}