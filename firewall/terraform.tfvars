custom_data = "cloud_init.txt"

load_balancer_param = {
  sku             = "basic"
  probe_protocol  = "Tcp" # probe protocol Http, Https, or Tcp
  probe_port      = "22"  # probe port. (1 ~ 65535)
  probe_interval  = "5"   # probe interval in sec
  probe_num       = "2"   # number of probes

}

services =   {
  0               = {
    name          = "svc-a"
    vm_num        = 2
    vm_size       = "Standard_D2s_v3"
    subnet        = "service-group1"
    subnet_ip_offset  = 10
    vm_publisher      = "Canonical"
    vm_offer          = "UbuntuServer"
    vm_sku            = "16.04.0-LTS"
    vm_version        = "latest"
  }
  1               = {
    name          = "svc-b"
    vm_num        = 2
    vm_size       = "Standard_D2s_v3"
    subnet        = "service-group2"
    subnet_ip_offset  = 10
    vm_publisher      = "Canonical"
    vm_offer          = "UbuntuServer"
    vm_sku            = "16.04.0-LTS"
    vm_version        = "latest"
  }

}

route_internet_out = {
  0             = {
    name                    = "route-to-internet"
    address_prefix          = "0.0.0.0/0"
    next_hop_type           = "VirtualAppliance"
    next_hop_in_ip_address  = "10.10.0.68"
  }
}

services_outbound =   {
  0               = {
    name          = "outbound"
  }
  1               = {
    name          = "outbound2"
  }
}

int_lb_frontend_ip =   {
  0               = {
    name          = "int-lb-frontend-0"
    ip_address    = "10.10.0.68"
  }
}


jumpbox_service   =   {
  0               = {
    name          = "jumpbox"
  }
}
 
int_lb_frontend_ip_offset = 4 # 1st available IP address in the subnet. First 4 IPs are reserved for management 

ext_nic_ip_offset         = 4 # 1st available IP address in the subnet. First 4 IPs are reserved for management 
int_nic_ip_offset         = 5 # 2nd available IP address in the subnet


vm_num_fortigate          = 5 # 3
vm_size_fortigate         = "Standard_F16s"
vm_size_fortimanager      = "Standard_D4s_v3"
vm_size_fortianalyzer     = "Standard_D2s_v3"


ip_offset_fortimanager          = 10 # 10th vailable IP address in the subnet
ip_offset_fortianalyzer         = 11 # 11th vailable IP address in the subnet


ip_addr_diags = {
 log = [
#["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period] 
   ["DDoSProtectionNotifications", true, true, 30],
   ["DDoSMitigationFlowLogs", true, true, 30],
   ["DDoSMitigationReports", true, true, 30],
 ]

 metric = [
   ["AllMetrics", true, true, 30],
 ]
}


