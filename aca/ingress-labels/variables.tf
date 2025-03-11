variable "region" {
  description = "Azure region to deploy to"
  default     = "canadaeast"
}

variable "tags" {
  description = "The name of the node pool"
  type        = string
  default     = "Basic ACA Environment"
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