variable "region" {
  description = "Azure region to deploy to"
  default     = "westus3"
}

variable "tags" {
  description = "Tags to apply to Resource Group"
}

variable "grafana_major_version" {
  description = "Grafana major version"
  default     = 11
}