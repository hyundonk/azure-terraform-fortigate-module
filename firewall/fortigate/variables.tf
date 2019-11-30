variable "prefix" {
  description = "(Required) prefix"   
}

variable "vm_num" {

}

variable "vm_size" {

}

variable "location" {
  description = "(Required) Location of the public IP to be created"   
}

variable "rg" {
  description = "(Required) Resourge group of the public IP to be created"    
}

variable "tags" {
  description = "(Required) Tags to be applied to the IP address to be created"
  
}

variable "external_subnet_id" {
  description = "subnet ID of external subnet"
}

variable "external_subnet_prefix" {
  description = "IP prefix of external subnet"
}

variable "internal_subnet_id" {
  description = "subnet ID of internal subnet"
}

variable "internal_subnet_prefix" {
  description = "IP prefix of internal subnet"
}

variable "ext_nic_ip_offset" {}
variable "int_nic_ip_offset" {}

variable "extlb_backend_address_pool_id" {
  description = "backend address pool ID of external load balancer"
}

variable "extlb_backend_outbound_address_pool_id" {
  description = "outbound backend address pool ID of external load balancer"
}

variable "intlb_backend_address_pool_id" {
  description = "backend address pool ID of internal load balancer"
}

variable "admin_username" {

}

variable "admin_password" {

}

