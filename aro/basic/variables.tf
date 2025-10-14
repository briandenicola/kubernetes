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

variable "aro_client_secret" {
  description = "The client secret of the SPN used by ARO"
}

variable "aro_client_id" {
  description = "The client ID of the SPN used by ARO"
}