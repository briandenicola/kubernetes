variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}

variable "tags" {
  description = "The value for RG tag"
}

variable "namespace" {
  default     = "default"
  description = "The namespace to deploy to"
}