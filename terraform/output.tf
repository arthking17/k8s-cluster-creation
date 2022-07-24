output "resource_group_name" {
  value = azurerm_resource_group.cluster.name
}

output "master_public_ip_address" {
  value = azurerm_linux_virtual_machine.master_node.public_ip_address
}

output "worker_public_ip_address" {
  value = azurerm_linux_virtual_machine.worker_node.public_ip_address
}