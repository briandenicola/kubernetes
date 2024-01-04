variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
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