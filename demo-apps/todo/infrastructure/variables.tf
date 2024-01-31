variable "certificate_name" {
  description   = "The name of the PFX file"
  type          = string
  default       = "my-wildcard-cert.pfx"
}

variable "namespace" {
  description   = "The namespace for the workload identity"
  type          = string
  default       = "todo-app"
}

variable "aks_name" {
  description = "The name of the AKS cluster"
}

variable "aks_rg_name" {
  description = "The RG name of the AKS cluster"
}

variable "aks_ip_address" {
  description = "value of the AKS outbound IP"
}

variable "ai_name" {
  description = "The name of the App Insights"
}

variable "ai_rg_name" {
  description = "The RG name of the App Insights"
}