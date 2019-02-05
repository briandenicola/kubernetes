variable "location" {
  description = "The Azure Region to deploy AKS"
  default = "centralus"
}
variable "cluster_name" {
  description = "The cluster name"
  default = "k8s04"
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
  description = "The Client Secret of the Service Principal"
}

variable "admin_user" {
  description = "The local administrator on Linux"
  default = "manager"
}

variable "ssh_public_key" {
  description = "The public key for the local administrator" 
}