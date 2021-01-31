az account show

rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup *tfplan
for n in $(az group list --query "[?contains(name, '-tc')].name" -o tsv); do echo $n; az group delete -n $n --no-wait --yes; done

terraform taint null_resource.db_seed; tpa
terraform taint null_resource.app_warmup; tpa
terraform taint azurerm_app_service_plan.asp; tpa

./TechChallengeApp updatedb -s
./TechChallengeApp serve

export TF_LOG=TRACE
export TF_LOG=
export TF_LOG_PATH=./terraform.log
code terraform.log
# export TF_IN_AUTOMATION=TRUE