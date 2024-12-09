variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}

variable "tags" {
  description = "Tags to apply to Resource Group"
}

variable "zones" {
  description = "Enable Availability Zones for the Container Apps Environment"
  type = bool
  default = true
}