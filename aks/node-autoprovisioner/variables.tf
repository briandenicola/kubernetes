variable "namespace" {
  description = "The namespace for the workload identity"
  type        = string
  default     = "default"
}

variable "enable_mesh" {
  description = "Enable Azure Service Mesh for cluster"
  default     = true
}

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
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags to apply to Resource Group"
}