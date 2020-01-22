## Quick deployment for single fortigate instance test

This directory contains terraform code and scripts that can deploy fortigate instance with required azure resources such as VNET, storage account, etc. 

To deploy fortigate instance.

1. login using azure CLI on bash shell
```
$ az login
```

2. Run terraform init. This will not use remote backend. terraform.tfstate file will be created in the local folder.
```
$ terraform init
```

3. Run terraform apply. This will deploy fortigate instance without customdata parameter for cloud-init. This will create "fortigatetest_rg" resource group and then other resources in it.
```
$ terraform apply
```

4. Copy fortigate license file as "license-01.lic" and run "prepare_fortigtate_bootstrap.sh". This will upload license file and config.txt file to azure blob storage and create customdata-01.txt file.
```
$ ./prepare_fortigate_bootstrap.sh
```

5. Modify "./fortigate/fortigate.tf" file to add "custom_data" parameter in os_profile block to enable cloud-int
```
  os_profile {
    computer_name   = format("%s-fw%02d", var.prefix, count.index + 1)
    admin_username  = var.admin_username
    admin_password  = var.admin_password
    custom_data     = filebase64(format("customdata-%02d.txt", count.index + 1)) # blocked temporary for debugging      
  }
``
6. On Azure portal, delete fortigate instance VM resource, os disk and disk disk. 

7. Run terraform apply again to create fortigate instance with cloud-init enabled.
```
$ terraform apply
```

```
