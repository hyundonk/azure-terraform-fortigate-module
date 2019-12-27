
output "service1" {
  value = module.service1
}

output "jumpbox_public_ip" {
  value = module.jumpbox_public_ip.public_ip
}

