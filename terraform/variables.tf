variable "resource_group_name_prefix" {
  default       = "k8s-cluster-rg"
  description   = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  default       = "North Europe"
  description   = "Location of the resource group."
}

variable "master_private_ip_address" {
  default       = "10.0.0.5"
  description   = "Private Ip address of the VM."
}

variable "worker_private_ip_address" {
  default       = "10.0.0.6"
  description   = "Private Ip address of the VM."
}