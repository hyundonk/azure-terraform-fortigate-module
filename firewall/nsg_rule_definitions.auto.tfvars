
nsg_rules_table = {
  "service-fwext" = {
    nsg_inbound   = [
      [
        /* name */                          "allow_http_https",
        /* priority */                      "1000", 
        /* direction */                     "Inbound", 
        /* action */                        "Allow",
        /* protocol */                      "Tcp",
        /* source port range */             "*",
        /* source port ranges */            null,
        /* source address prefix */         "*",
        /* source address prefixes */       null,
        /* destination port range */        null, 
        /* destination port ranges */       ["80", "443"],
        /* destination address prefix */    "*",
        /* destination address prefixes */  null
      ],

    ]
    nsg_outbound  = []
  }
  "service-fwint" = {
    nsg_inbound   = [
       [
        /* name */                          "allow_http_https_vnet_to_internet",
        /* priority */                      "1000", 
        /* direction */                     "Inbound", 
        /* action */                        "Allow",
        /* protocol */                      "Tcp",
        /* source port range */             "*",
        /* source port ranges */            null,
        /* source address prefix */         "VirtualNetwork",
        /* source address prefixes */       null,
        /* destination port range */        null, 
        /* destination port ranges */       ["80", "443"],
        /* destination address prefix */    "0.0.0.0/0",
        /* destination address prefixes */  null
      ],
    ]
    nsg_outbound  = []
  }
  "service-management" = {
    nsg_inbound   = [
      [
        /* name */                          "allow_ssh_to_jumpbox",
        /* priority */                      "1000", 
        /* direction */                     "Inbound", 
        /* action */                        "Allow",
        /* protocol */                      "Tcp",
        /* source port range */             "*",
        /* source port ranges */            null,
        /* source address prefix */         "*",
        /* source address prefixes */       null,
        /* destination port range */        "22", 
        /* destination port ranges */       null,
        /* destination address prefix */    "10.10.0.140",
        /* destination address prefixes */  null
      ],
      [
        /* name */                          "allow_tcp_8000_9000",
        /* priority */                      "2000", 
        /* direction */                     "Inbound", 
        /* action */                        "Allow",
        /* protocol */                      "Tcp",
        /* source port range */             "*",
        /* source port ranges */            null,
        /* source address prefix */         "*",
        /* source address prefixes */       null,
        /* destination port range */        "8000-9000", 
        /* destination port ranges */       null,
        /* destination address prefix */    "10.10.0.140",
        /* destination address prefixes */  null
      ],
   ]
    nsg_outbound  = []
  }
  "fwtest-client" = {
    nsg_inbound   = [
      [
        /* name */                          "allow_tcp_65503_65534",
        /* priority */                      "1000", 
        /* direction */                     "Inbound", 
        /* action */                        "Allow",
        /* protocol */                      "Tcp",
        /* source port range */             "*",
        /* source port ranges */            null,
        /* source address prefix */         "GatewayManager",
        /* source address prefixes */       null,
        /* destination port range */        "65200-65535", #"65503-65534", 
        /* destination port ranges */       null,
        /* destination address prefix */    "*",
        /* destination address prefixes */  null
      ],
      [
        /* name */                          "allow_from_azure_loadb_balancer",
        /* priority */                      "1100", 
        /* direction */                     "Inbound", 
        /* action */                        "Allow",
        /* protocol */                      "*",
        /* source port range */             "*",
        /* source port ranges */            null,
        /* source address prefix */         "AzureLoadBalancer",
        /* source address prefixes */       null,
        /* destination port range */        "*", 
        /* destination port ranges */       null,
        /* destination address prefix */    "*",
        /* destination address prefixes */  null
      ],
    ]
    nsg_outbound  = [
    ]
  }
}
 
