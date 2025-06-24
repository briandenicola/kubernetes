variable "nodepool_name" {
  description = "The name of the node pool"
  type        = string
  default     = "system"
}

variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}

variable "vm_size" {
  description = "The value for the VM SKU"
}

variable "node_count" {
  description = "The node count for the default node pool"
}

variable "enable_managed_offerings" {
  description = "Deploy with Managed Prometheus and Managed Grafana"
  default     = true
}

variable "tags" {
  description = "Tags to apply for this resource"
  default     = "Azure Container Storage Demo"
}
