variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}

variable "resource_name" {
  description = "The root value to use for naming resources"
}

variable "sdlc_environment" {
  description = "The value for the sdlc environment"
}

variable "tags" {
  description = "Tags to apply for this resource"
}

variable "enable_managed_offerings" {
  description = "Deploy Managed Prometheus and Managed Grafana"
  default     = true
}