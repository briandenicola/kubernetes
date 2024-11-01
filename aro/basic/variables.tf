variable "region" {
  description = "Region to deploy resources to"
}

variable "aro_rp_aad_sp_object_id" {
  description = "Azure Red Hat OpenShift RP"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
}

variable "domain" {
  description = "Domain name"
  type        = string
}
