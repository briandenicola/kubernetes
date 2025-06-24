variable "resource_name" {
  description = "The value for the resource name prefix"
}

variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}

variable "vm_size" {
  description = "The value for the VM SKU"
  default     = "Standard_D4ads_v5"
}

variable "vm_os" {
  description = "The value for the VM OS"
  default     = "AzureLinux"
}

variable "tags" {
  description = "Tags to apply for this resource"
}

variable "node_count" {
  description = "The node count for the default node pool"
  default     = 1
}

variable "authorized_ip_ranges" {
  description = "Authorized IP ranges for accessing the cluster"
  default     = null
}

variable "zones" {
  description = "The zones to deploy the cluster to"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "sdlc_environment" {
  description = "The value for the sdlc environment"
}

variable "public_key_openssh" {
  description = "The public key to use for SSH access to the cluster"
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to deploy"
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