variable "location" {
  description = "The location for this application deployment"
}

variable "tags" {
  description = "The value for the tags applied to the resource group"
}

variable "primary_location" {
  description = "The primary location for this application deployment"
}

variable "app_name" {
  description = "The root name for this application deployment"
}

variable "authorized_ip_ranges" {
    description = "The IP ranges that are allowed to access the Azure resources"
}