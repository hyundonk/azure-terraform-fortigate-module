services =   {
  0               = {
    name          = "serviceA"
    vm_num        = 2
    vm_size       = "Standard_D2s_v3"
    subnet        = "serviceA-subnet"
    subnet_ip_offset  = 10
    vm_publisher      = "Canonical"
    vm_offer          = "UbuntuServer"
    vm_sku            = "16.04.0-LTS"
    vm_version        = "latest"
  }
  1               = {
    name          = "serviceB"
    vm_num        = 2
    vm_size       = "Standard_D2s_v3"
    subnet        = "serviceB-subnet"
    subnet_ip_offset  = 10
    vm_publisher      = "Canonical"
    vm_offer          = "UbuntuServer"
    vm_sku            = "16.04.0-LTS"
    vm_version        = "latest"
  }
  2               = {
    name          = "serviceC"
    vm_num        = 2
    vm_size       = "Standard_D2s_v3"
    subnet        = "serviceC-subnet"
    subnet_ip_offset  = 20
    vm_publisher      = "MicrosoftWindowsServer"
    vm_offer          = "WindowsServer"
    vm_sku            = "2016-Datacenter"
    vm_version        = "latest"
  }
  3               = {
    name          = "serviceD"
    vm_num        = 2
    vm_size       = "Standard_D2s_v3"
    subnet        = "serviceD-subnet"
    subnet_ip_offset  = 30
    vm_publisher      = "MicrosoftWindowsServer"
    vm_offer          = "WindowsServer"
    vm_sku            = "2016-Datacenter"
    vm_version        = "latest"
  }
}

services_outbound =   {
  0               = {
    name          = "outbound"
  }
}

int_lb_frontend_ip_offset = 4 # 1st available IP address in the subnet. First 4 IPs are reserved for management 

ext_nic_ip_offset         = 4 # 1st available IP address in the subnet. First 4 IPs are reserved for management 
int_nic_ip_offset         = 5 # 2nd available IP address in the subnet


vm_num_fortigate          = 2 # 3
vm_size_fortigate         = "Standard_F4s"
vm_size_fortimanager      = "Standard_D2s_v3"
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


