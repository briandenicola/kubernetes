variable "region" {
  description = "The Azure region where the AKS cluster will be deployed"
  type        = string
}

variable "resource_name" {
  description = "The base name for all resources created by this module"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = string

}

variable "sdlc_environment" {
  description = "The software development lifecycle environment (e.g., dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "aks_cluster" {
  type = object({
    name               = string
    kubernetes_version = string
    public_key_openssh = string
    allowed_ip_ranges  = string
    zones              = list(string)
    istio = object({
      enabled = bool
      version = string
    })
    nodes = object({
      sku   = string
      count = number
      os    = string
    })
    logs = object({
      workspace_id = string
    })
  })
}
