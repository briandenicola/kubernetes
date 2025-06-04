variable "region" {
  description = "Region to deploy in Azure"
}

variable "zones" {
  description = "The zones to deploy the cluster to"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable tags {
  description = "Tags to be applied to all resources"
}

variable "node_sku" {
  description = "The value for the VM SKU"
  default     = "Standard_D4ads_v5"
}

variable "node_count" {
  description = "The value for the VM SKU"
  default     = 1
}

variable "deploy_flux_extension" {
  description = "Deploy Flux Extension"
  default     = true
}

variable "deploy_jumpbox" {
  description = "Deploy Jumpbox"
  default     = true
}