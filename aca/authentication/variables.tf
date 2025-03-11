variable "region" {
  description = "Azure region to deploy to"
  default     = "canadaeast"
}

variable "tags" {
  description = "The name of the node pool"
  type        = string
  default     = "Basic ACA Environment"
}

variable "zones" {
  description = "Enable Availability Zones for the Container Apps Environment"
  type = bool
  default = true
}