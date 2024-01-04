variable regions {
  description = "The location for this application deployment"
  type        = list(string)
}

variable "hub_region" {
  description = "Azure region to deploy Fleet Manager to"
  default     = "southcentralus"
}