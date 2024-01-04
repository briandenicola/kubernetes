variable sdlc_environments {
  description = "The sdlc environments for this application deployment"
  type        = list(string)
  default     = ["development","staging","production"]
}

variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}