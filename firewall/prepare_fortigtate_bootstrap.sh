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

export exist=$(az storage container exists --name  ${container} | jq .exists)

export configfile="config.txt"
export license_01_file="license-01.lic"
export license_02_file="license-02.lic"

if [ $exist == "false" ]
then 
  echo "creating ${container} container"
  az storage container create --name ${container} --public-access blob
  # try again to make sure it is created
  az storage container create --name ${container} --public-access blob
else
  echo "Use existing ${container} container"
fi

echo "upload... config file and license files..."
if [ -e $configfile ]
then
  az storage blob upload --container-name ${container} --name config/config.txt --file ${configfile}
  config_url=$(az storage blob url --container-name ${container} --name config/config.txt)
#  echo "creating URL with SAS key for config file.."
#  config_url=$(az storage blob generate-sas --account-name ${storage_account_name} --account-key ${access_key} --container-name ${container} --name config/config.txt --permissions r --expiry 2022-12-31 --full-uri)
  echo "${config_url} uploaded successfully"
else
  echo "$configfile is missing"
  exit 0
fi

if [ -e $license_01_file ]
then
  az storage blob upload --container-name ${container} --name license/license-01.lic --file $license_01_file
  license_01_url=$(az storage blob url --container-name ${container} --name license/license-01.lic)
  #echo "creating URL with SAS key for 1st instance license file.."
  #license_01_url=$(az storage blob generate-sas --account-name ${storage_account_name} --account-key ${access_key} --container-name ${container} --name license/license-01.lic --permissions r --expiry 2022-12-31 --full-uri)
  echo "creating customdata file for 1st instance..."
  echo -e "{\"config-url\": ${config_url},\n\"license-url\": ${license_01_url}}\n" > customdata-01.txt
fi

if [ -e $license_02_file ]
then
  az storage blob upload --container-name ${container} --name license/license-02.lic --file $license_02_file
  license_02_url=$(az storage blob url --container-name ${container} --name license/license-02.lic)
  #echo "creating URL with SAS key for 2nd instance license file.."
  #license_02_url=$(az storage blob generate-sas --account-name ${storage_account_name} --account-key ${access_key} --container-name ${container} --name license/license-02.lic --permissions r --expiry 2022-12-31 --full-uri)
  echo "creating customdata file for 2nd instance..."
  echo -e "{\"config-url\": ${config_url},\n\"license-url\": ${license_02_url}}\n" > customdata-02.txt
fi
