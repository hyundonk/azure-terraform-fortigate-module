
output "jumpbox_public_ip" {
  value = {
    for ip in module.jumpbox_public_ip.public_ip:
       ip.name => ip.ip_address
  }
}

