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