variable "regions" {
  description = "The location for this application deployment"
  default = ["westus3", "canadaeast"]
}

variable "tags" {
  description = "The value for the tags applied to the resource group"
}