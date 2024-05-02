variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}

variable "ingress_labels" {
  description = "Ingress labels for the app"
  type        = map(object({
    label           = string
    latest_revision = bool
    traffic_weight  = number
    revision_suffix = string
  }))
}