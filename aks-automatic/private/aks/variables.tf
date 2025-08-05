variable "resource_name" {
  description = "The value for the resource name prefix"
}

variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}

variable "tags" {
  description = "Tags to apply for this resource"
}

variable "sdlc_environment" {
  description = "The value for the sdlc environment"
}

variable "azurerm_log_analytics_workspace_id" {
  description = "The resource id for the log analytics workspace"
}

variable "azurerm_subnet_nodes_id" {
  description = "The resource id for the subnet where the AKS nodes will be deployed to" 
}

variable "azurerm_virtual_network_id" {
  description = "The resource id for the virtual network where the AKS cluster will be deployed to"
}