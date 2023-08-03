variable "namespace" {
  description   = "The namespace for the workload"
  type          = string
  default       = "default"
}

variable "region" {
  description = "Region to deploy resources to"
  default     =  "southcentralus"
}