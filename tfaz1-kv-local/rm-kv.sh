# keyvault soft delete is now enabled by default on azure. to remove ALL keyvaults use this script
# https://docs.microsoft.com/en-us/azure/key-vault/general/soft-delete-change
# CAUTION: THIS SCRIPT REMOVES KEYVAULT IMMEDIATELY. DEVELOPMENT USE ONLY. 

# list of keyvaults
az keyvault list --query '[].name' -o tsv
# list of soft deleted keyvaults
az keyvault list-deleted --query '[].name' -o tsv

n=KeyVaultName
az keyvault delete -n $n
az keyvault purge -n $n

