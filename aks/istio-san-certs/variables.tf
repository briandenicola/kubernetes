variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}

variable "zones" {
  description = "The values for the zones to deploy AKS to"
  default     = ["1"]
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

variable "certificate_base64_encoded" {
  description = "TLS Certificate for Istio Ingress Gateway"
}

variable "certificate_password" {
  description = "Password for TLS Certificate"
}

variable "certificate_name" {
  description = "The name of the certificate to use for TLS"
  default     = "san-certificate"
}

variable "service_mesh_type" {
  description = "Type of Service Mesh for cluster"
  default     = "istio"
}
