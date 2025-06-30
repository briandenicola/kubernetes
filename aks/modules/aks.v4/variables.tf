variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}

variable "authorized_ip_ranges" {
  description = "Authorized IP ranges for accessing the cluster"
  default     = null
}

variable "resource_name" {
  description = "The root value to use for naming resources"
}

variable "public_key_openssh" {
  description = "The public key to use for SSH access to the cluster"
}

variable "vm_sku" {
  description = "The value for the VM SKU"
  default     = "Standard_D4ads_v5"
}

variable "vm_os" {
  description = "The value for the VM OS"
  default     = "AzureLinux"
}

variable "sdlc_environment" {
  description = "The value for the sdlc environment"
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to deploy"
}

variable "istio_version" {
  description = "The version of the managed Azure Service Mesh to deploy"
  type = list(string)
  default     = ["asm-1-24"]
}

variable "automatic_channel_upgrade" {
  default     = "patch"
  description = "The value for the automatic channel upgrade"
}

variable "node_os_channel_upgrade" {
  default     = "NodeImage"
  description = "The value for the node OS channel upgrade"
}

variable "tags" {
  description = "Tags to apply for this resource"
}

variable "enable_mesh" {
  description = "Enable service mesh"
  default     = true
}

variable "enable_csi_drivers" {
  description = "Enable CSI drivers"
  default     = true
}

variable "node_labels" {
  description = "The labels to apply to the nodes"
  type        = map(string)
  default     = {}
}

variable "node_count" {
  description = "The node count for the default node pool"
  default     = 1
}

variable "zones" {
  description = "The zones to deploy the cluster to"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "only_critical_addons_enabled" {
  description = "Enable only critical addons for default system pool"
  default     = false
}

variable "msi_auth_for_monitoring_enabled" {
  description = "Enable MSI auth for monitoring"
  default     = false
}

variable "azurerm_log_analytics_workspace_id" {
  description = "The resource id for the log analytics workspace"
}

variable "cni_plugin_mode" {
  description = "The CNI plugin mode to use"
  default     = "overlay"
}

variable "enable_addons" {
  default = false 
}

variable "network_policy_engine" {
  description = "The network policy engine to use"
  default     = "cilium"
  
}