variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}

variable "namespace" {
  default     = "default"
  description = "The namespace to deploy to"
}

variable "enable_managed_offerings" {
  description = "Deploy with Managed Prometheus and Managed Grafana"
  default     = true
}