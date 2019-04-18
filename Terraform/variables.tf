variable "location" {
  description = "The Azure Region to deploy AKS"
  default = "centralus"
}

variable "k8s_vnet_resource_group_name" {
  description = "The Resource Group name that contains the Vnet for AKS"  
}

variable "k8s_subnet" {
  description = "The subnet name where AKS will be deployed to"
}

variable "k8s_vnet" {
  description = "The Vnet name where AKS will be deployed to"
}

variable "dns_service_ip" {
    description = "The IP address for the DNS serviced hosted inside AKS cluster"
}

variable "service_cidr" {
  description = "The IP range for internal services in AKS. Should not overlap any other IP space "
}
variable "cluster_name" {
  description = "The cluster name"
}

variable "cluster_version" {
  description = "The cluster version"
  default = "1.12.6"
}

variable "resource_group_name" {
  description = "The Azure Resource Group to deploy AKS"
}

variable "agent_count" {
  description = "The number of nodes in the cluster"
  default = "2"
}

variable "vm_size" {
  description = "The VM node size"
  default = "Standard_B4ms"
}

variable "client_id" {
  description = "The Client Id of the Service Principal"
}

variable "client_secret" {
  description = "The Storage Account Key"
}

variable "admin_user" {
  description = "The local administrator on Linux"
  default = "manager"
}

variable "ssh_public_key" {
  description = "The public key for the local administrator" 
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGUfWYw+OI3udPmdcIklEeLapnR/9boHLNOpHwglZ+fxv959rjmXyq+ZB55xfHQqjYgvUARLbYmvnBgIpDDI95fo2tepHjspvw4nmM1OwRCt+DwY7Y7Rmq/5LRIj6RvJe0V2TsS8xE0VI907zLoatqQ6cO9kedlbr9KY4ZrRXYHOZWapHqcliyI29lZIPGdmAFjmtdkngmu4sgss9V+2gwWghp+bnMXyyn96oBxeQjCNDiP/90yucjYgoDPHslkLXc7jgdfnb+oxa0iG9bHutzgTdQ7ZkCZOnd++ZJISIvKhIIJAfqaQNVY1B7cXzFDcTJbZxpptZvKbaUaWhRS1uJ briandenicola@harpocrates.denicolafamily.com"
}

variable "log_analytics_workspace_name" {
  description = "The name for the Log Analytics Workspace"
  default = "bjdloganalytics003"
}

variable "environment" {
  description = "The environment this cluster is"
}

