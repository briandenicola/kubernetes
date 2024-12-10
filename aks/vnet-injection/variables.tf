variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}

variable "vm_size" {
  description = "The SKU for the default node pool"
  default     = "Standard_B4ms"
}

variable "node_count" {
  description = "The default number of nodes to scale the cluster to"
  default     = 1
}

variable "nodepool_name" {
  description = "The name of the node pool"
  type        = string
  default     = "system"
}

variable "tags" {
  description = "The name of the node pool"
  type        = string
  default     = "Basic AKS Cluster"
}