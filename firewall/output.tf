/*
output "public_ip" {
  value = module.public_ip_address.public_ip
}
*/
output "ext_load_balancer_frontend_ip_outbound" {
  value = {
    for ip in module.public_ip_address_outbound.public_ip:
       ip.name => ip.ip_address
  }
  #value = module.public_ip_address_outbound.public_ip
}

/*
output "extlb_backend_address_pool_id" {
  value = module.external_load_balancer.backend_address_pool_id
}

output "extlb_backend_outbound_address_pool_id" {
  value = module.external_load_balancer.backend_outbound_address_pool_id
}
*/

