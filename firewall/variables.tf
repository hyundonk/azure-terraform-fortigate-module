# variables defined from environmental variables
variable "lowerlevel_storage_account_name" {}
variable "lowerlevel_container_name" {}
variable "lowerlevel_resource_group_name" {}

variable "fortigate_adminusername" {}
variable "fortigate_adminpassword" {}

variable "prefix" {}
variable "services" {}
variable "services_outbound" {}

variable "jumpbox_service" {}

variable "ip_addr_diags" {}

variable "vm_num_fortigate" {
        
}

variable "vm_size_fortigate" {

}

variable "vm_size_fortimanager" {
        
}

variable "vm_size_fortianalyzer" {}

variable "int_lb_frontend_ip" {}

variable "int_lb_frontend_ip_offset" {}

variable "ext_nic_ip_offset"  {

}

variable "int_nic_ip_offset" {}

variable "ip_offset_fortimanager" {}

variable "ip_offset_fortianalyzer" {}

variable "route_internet_out" {}
