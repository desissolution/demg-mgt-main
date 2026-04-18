output "resource_group_name" {
  description = "The name of the resource group."
  value       = local.resource_group_name
}

output "virtual_network_name" {
  description = "The name of the virtual network."
  value       = module.virtual_network.name
}

output "virtual_network_id" {
  description = "The resource ID of the virtual network."
  value       = module.virtual_network.resource_id
}

output "subnet_ids" {
  description = "Map of subnet names to their resource IDs."
  value       = { for k, v in module.virtual_network.subnets : k => v.resource_id }
}

output "virtual_machine_name" {
  description = "The name of the virtual machine."
  value       = module.virtual_machine.name
}

output "virtual_machine_id" {
  description = "The resource ID of the virtual machine."
  value       = module.virtual_machine.resource_id
}

output "virtual_machine_private_ip" {
  description = "The private IP address of the virtual machine."
  value       = module.virtual_machine.network_interfaces["private"].private_ip_addresses
}
