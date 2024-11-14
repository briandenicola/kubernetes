output "RESOURCE_GROUP" {
  value     = azurerm_resource_group.this.name
  sensitive = false
}

output "ARO_NAME" {
  value     = local.aro_name
  sensitive = false
}

output "ARO_CONSOLE_URL" {
  value = azurerm_redhat_openshift_cluster.this.console_url
  sensitive = false
}

output "ARO_API_SERVER_IP" {
  value = azurerm_redhat_openshift_cluster.this.api_server_profile[0].ip_address 
  sensitive = false
}

output "ARO_INGRESS_IP" {
  value = azurerm_redhat_openshift_cluster.this.ingress_profile[0].ip_address 
  sensitive = false
}