variable "vm" {
  type = object({
    name                = string
    location            = string
    zone                = number 
    resource_group_name = string
    sku                 = string
    admin = object({
      username = string
      ssh_key_path        = string
    })
    vnet = object({
      subnet_id = string
    })
  })
}
