variable "vm" {
  type = object({
    name                = string
    location            = string
    zone                = number 
    resource_group_name = string
    tags                = string
    sku                 = string
    admin = object({
      username = string
      ssh_key_path        = string
    })
    vnet = object({
      id          = string
      subnet_id = string
    })
  })
}

variable "resource_name" {
  type        = string
  description = "Prefix for all resources created by this module"
  
}