variable "region" {
  description = "Region to deploy resources to"
}

variable "tags" {
  description = "Tags to apply to all resources"
}

variable "domain" {
  description = "Domain name"
  type        = string
}

variable "pull_secret" {
  description = "Red Hat pull secret (optional)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "cluster_version" {
  description = "ARO cluster version"
  type        = string
  default     = "4.16.48"
}

variable "fips_enabled" {
  default     = false
  description = "Enable FIPS validated modules"
  type        = bool
}

variable "cluster_type" {
  description = "Type of ARO cluster API and Ingress visibility: Public or Private"
  type        = string
  default     = "Private"
}

variable "host_encryption_enabled" {
  default     = true
  description = "Enable host base encryption at rest"
  type        = bool
}