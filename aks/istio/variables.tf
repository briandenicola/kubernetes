variable "namespace" {
  description   = "The namespace for the workload identity"
  type          = string
  default       = "default"
}

variable "service_mesh_type" {
  description = "Type of Service Mesh for cluster"
  default     = "istio"
}

variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}