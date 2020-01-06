
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
    nsg_inbound   = []
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
    ]
    nsg_outbound  = []
  }
}
 
