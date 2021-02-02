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

rgname=dev-app1-db
dbservername=dev-app1-33421
dbname=app1
dbservernameurl=$dbservername.postgres.database.azure.com
dblogin=login@$dbservername

myip=$(dig +short myip.opendns.com @resolver1.opendns.com)
az postgres server firewall-rule create -g ${rgname} -s ${dbservername} -n updatedbIpDeleteme --start-ip-address $myip --end-ip-address $myip
echo "./TechChallengeApp updatedb -s" > updatedb.sh
docker volume create myvolume
docker run -d --name dummy -v myvolume:/root alpine tail -f /dev/null
docker cp -a updatedb.sh dummy:/root/updatedb.sh
docker rm -f dummy
docker run --rm -p 3000:3000 -e VTT_DBUSER=${dblogin} -e VTT_DBPASSWORD=$VTT_DBPASSWORD -e VTT_DBNAME=$dbname -e VTT_DBPORT=5432 -e VTT_DBHOST=${dbservername}.postgres.database.azure.com -e VTT_LISTENHOST=0.0.0.0 -e VTT_LISTENPORT=3000 -v myvolume:/root --entrypoint /bin/ash servian/techchallengeapp:latest -c /root/updatedb.sh
az postgres server firewall-rule delete --yes -g ${rgname} -s ${dbservername} -n updatedbIpDeleteme

terraform taint null_resource.db_seed

docker run --rm -p 3000:3000 -e VTT_DBUSER=login@dev-app1-33421 -e VTT_DBPASSWORD=9bycaANbB5zsuuvBbSkh_ -e VTT_DBNAME=app1 -e VTT_DBPORT=5432 -e VTT_DBHOST=dev-app1-33421.postgres.database.azure.com -e VTT_LISTENHOST=0.0.0.0 -e VTT_LISTENPORT=3000 -v myvolume:/root --entrypoint /bin/ash servian/techchallengeapp:latest -c /root/updatedb.sh

docker run --rm servian/techchallengeapp:latest
docker run --rm -v myvolume:/root --entrypoint /bin/ash servian/techchallengeapp:latest -c /root/updatedb.sh