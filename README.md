# Azure Terraform module for Fortigate NGFW

This is Azure terraform module for deploying Fortigate NGFW to Azure virtual network in High-Available and scalible (N Active-Active) configuration.

Work in progress. Please stay tuned.

## Network Architecture
![Fortigate on Azure Network Architecture](images/network_architecture.png)

This terraform module deploys N fortigate firewall instances in Active-Active modes along with Azure Standard load balancers. Each instance has 2 NIC configurations, one for external subnet and the other for internet subnet.

The use case scenario includes:
1. Inbound traffic from external Azure Standard Load Balancer is filtered at fortigate firewall instance and DNATed to internal service IP addresss (e.g. internal web server in frontend subnet)
2. Outbound traffic originated from frontend subnet is sent to internal Azure Standard Load Balancer which is then filtered at fortigate firewall instance before leaving virtual network.
3. inter-subnet traffic filtering. traffic from frontend subnet to backend subnet is sent to internal Azure Standard Load Balancer which is then filtered at fortigate firewalll instance and then sent to destination subnet. 
4. The scenarios above can be extended to multiple VNETs environment in hub-and-spoke architecture. 

## terraform configuraiton files structure


## Bootstrapping Fortigate instances
Running Fortigate instance requires license and initial boot straping as described below link.
https://docs.fortinet.com/vm/azure/fortigate/5.6/deploying-fortigate-on-azure/5.6.0/295297/bootstrapping-the-fortigate-cli-and-byol-license-at-initial-bootup-using-user-data



## Tenical Notes
