#!/bin/bash

# This script does preparation jobs for fortigate instance bootstraping. Specifically, it does
# 1. Upload config.txt file and fortigate license files to azure blob storage.
# 2. create SAS key (read permission) for uploaded blobs.        
# 3. Create customdata-(%02d).txt files which contains the blob URLs with SAS key for the respective config file and license file.

# todo to be replaced with SAS key - short ttl or msi with the rover
id=$(az resource list --tag stgtfstate=level0 | jq -r .[0].id)
stg=$(az storage account show --ids ${id})
 
export storage_account_name=$(echo ${stg} | jq -r .name) && echo " - storage_account_name: ${storage_account_name}"
export resource_group=$(echo ${stg} | jq -r .resourceGroup) && echo " - resource_group: ${resource_group}"
export access_key=$(az storage account keys list --account-name ${storage_account_name} --resource-group ${resource_group} | jq -r .[0].value)
export container="fortigate"

export AZURE_STORAGE_ACCOUNT=${storage_account_name}
export AZURE_STORAGE_KEY=${access_key}

echo "upload... config file and license files..."
az storage blob upload --container-name ${container} --name config/config.txt --file config.txt
az storage blob upload --container-name ${container} --name license/license-01.lic --file license-01.lic
az storage blob upload --container-name ${container} --name license/license-02.lic --file license-02.lic

echo "creating URL with SAS key for config file.."
config_url=$(az storage blob generate-sas --account-name ${storage_account_name} --account-key ${access_key} --container-name ${container} --name config/config.txt --permissions r --expiry 2022-12-31 --full-uri)
echo "${config_url} created successfully"

echo "creating URL with SAS key for 1st instance license file.."
license_01_url=$(az storage blob generate-sas --account-name ${storage_account_name} --account-key ${access_key} --container-name ${container} --name license/license-01.lic --permissions r --expiry 2022-12-31 --full-uri)

echo "creating customdata file for 1st instance..."
echo -e "{\"config-url\": ${config_url},\n\"license-url\": ${license_01_url}}\n" > customdata-01.txt

echo "creating URL with SAS key for 2nd instance license file.."
license_02_url=$(az storage blob generate-sas --account-name ${storage_account_name} --account-key ${access_key} --container-name ${container} --name license/license-02.lic --permissions r --expiry 2022-12-31 --full-uri)

echo "creating customdata file for 2nd instance..."
echo -e "{\"config-url\": ${config_url},\n\"license-url\": ${license_02_url}}\n" > customdata-02.txt



