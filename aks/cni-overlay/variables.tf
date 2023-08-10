variable "namespace" {
  description   = "The namespace for the workload identity"
  type          = string
  default       = "default"
}

variable "region" {
  description = "Region to deploy in Azure"
  default     = "northcentralus"
}