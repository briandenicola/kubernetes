variable "namespace" {
  description   = "The namespace for the workload identity"
  type          = string
  default       = "default"
}



variable "service_mesh_type" {
  description = "Type of Service Mesh for cluster"
  default     = "istio"
}

variable "flux_secret_value" {
  default     = "Super secret value. Never check into github"
  description = "The secret value for http-credentials"
}