variable "bastion_host" {
  type = object({
    name                = string
    location            = string
    resource_group_name = string
    vnet = object({
      id = string
    })
  })
}