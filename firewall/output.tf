
output "public_ip" {
  value = module.public_ip_address
}

output "public_ip_outbound" {
  value = module.public_ip_address_outbound
}

output "extlb_backend_address_pool_id" {
  value = module.external_load_balancer.backend_address_pool_id
}

output "extlb_backend_outbound_address_pool_id" {
  value = module.external_load_balancer.backend_outbound_address_pool_id
}


