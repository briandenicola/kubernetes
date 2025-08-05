variable "region" {
  description = "Region to deploy in Azure"
}

variable tags {
  description = "Tags to be applied to all resources"
}

variable "deploy_jumpbox" {
  description = "Deploy Jumpbox"
  default     = true
}