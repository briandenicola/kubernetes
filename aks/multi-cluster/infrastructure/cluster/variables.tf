variable "region" {
  description = "Azure region to deploy to"
}

variable "tags" {
  description = "The tags to apply to the resources"
}

variable "authorized_ip_ranges" {
  description = "Authorized IP ranges for accessing the cluster"
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

variable "sdlc_environment" {
  description = "The value for the sdlc environment"
}

variable kubernetes_version {
  description = "The version of Kubernetes to deploy"
}

variable automatic_channel_upgrade {
  default     =  "patch"
  description = "The value for the automatic channel upgrade"
}

variable node_os_channel_upgrade {
  default     =  "NodeImage"
  description = "The value for the node OS channel upgrade"
}