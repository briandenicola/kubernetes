variable sdlc_environments {
  description = "The sdlc environments for this application deployment"
  type        = list(string)
  default     = ["development","staging","production"]
}

variable "region" {
  description = "Azure region to deploy to"
}

variable automatic_channel_upgrade {
  description = "The value for the automatic channel upgrade"
}

variable node_os_channel_upgrade {
  description = "The value for the node OS channel upgrade"
}

variable "tags" {
  description = "The tags to apply to the resources"
}