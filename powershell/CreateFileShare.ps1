# https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-cli

$rgName="rg-camunda"
$region="southeastasia"
$shareName="camundashare"
$accountName="robsapacstorage"
#$RANDOM

#Create resource group
az group create --name $rgName --location $region

#Create storage account
az storage account create --resource-group $rgName --name $accountName --location $region --kind StorageV2 --sku Standard_LRS --enable-large-file-share --output none

#Fetch storage account key
#$storageAccountKey=$(az storage account keys list --resource-group $rgName --account-name $storageAccountName --query "[0].value" | tr -d '"')
$storageAccountKey=(Get-AzStorageAccountKey -ResourceGroupName $rgName -Name $accountName)[0].Value

#Fetch storage account key
az storage share create --account-name $accountName --account-key $storageAccountKey --name $shareName --quota 5 --output none