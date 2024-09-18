
variable "region" {
  description = "Azure region to deploy to"
  default     = "canadaeast"
}

variable "vm_size" {
  description = "The SKU for the default node pool"
  default     = "Standard_B4ms"
}

variable "node_count" {
  description = "The default number of nodes to scale the cluster to"
  default     = 1
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = string
}

variable "zones" {
  description = "Availability zones to deploy the cluster to"
  type        = list(string)
  default     = [ "1", "2", "3" ]
}