variable "aks_cluster" {
  type = object({
    name     = string
    location = string
    resource_group = object({
      name = string
      id   = string
    })
    version = string
    istio = object({
      version = list(string)
    })
    nodes = object({
      sku   = string
      count = number
    })
    vnet = object({
      id = string
      node_subnet = object({
        id = string
      })
      mgmt_subnet = object({
        id = string
      })
    })
    logs = object({
      workspace_id = string
    })
    container_registry = object({
      id = string
    })
    flux = object({
      enabled    = bool
    })
  })
}

variable "zones" {
  description = "The zones to deploy the cluster to"
  type        = list(string)
  default     = ["1", "2", "3"]
}