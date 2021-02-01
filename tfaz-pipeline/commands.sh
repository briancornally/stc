az account show

for d in {2..3}; do cp -v ../tfaz0/backend-config.txt ../tfaz$d; done
rm -rf .terraform* *terraform* tfplan
man rm 

terraform taint null_resource.db_seed; tpa
terraform taint null_resource.app_warmup; tpa
terraform taint azurerm_app_service_plan.asp; tpa
terraform taint azurerm_key_vault.kv; tpa

./TechChallengeApp updatedb -s
./TechChallengeApp serve

export TF_LOG=TRACE
export TF_LOG=
export TF_LOG_PATH=./terraform.log
code terraform.log
# export TF_IN_AUTOMATION=TRUE


objectId=$(az ad sp list --display-name dev-app1-79206 --query "[].objectId" -o tsv)
echo $objectId
az keyvault set-policy --name dev-tc-kv --object-id $objectId --secret-permissions get
keyvaultid=$(az keyvault secret show --name dbpassword --vault-name dev-tc-kv --query id -o tsv)
echo "@Microsoft.KeyVault(SecretUri=$keyvaultid)"
