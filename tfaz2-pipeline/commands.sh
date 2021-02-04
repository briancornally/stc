az account show

docker 

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


dbservername=dev-app1-33421
rgname=dev-app1-db
dbname=app1
dbservernameurl=$dbservername.postgres.database.azure.com
dblogin=login@$dbservername
VTT_DBPASSWORD=$TF_VAR_dbpassword

echo "./TechChallengeApp updatedb -s" > updatedb.sh
myip=$(dig +short myip.opendns.com @resolver1.opendns.com)
az postgres server firewall-rule create -g $rgname -s $dbservername -n updatedbIpDeleteme --start-ip-address $myip --end-ip-address $myip
docker rm -f stc; docker run -td --name stc -p 3000:3000 -e VTT_DBUSER=$dblogin -e VTT_DBPASSWORD=$VTT_DBPASSWORD -e VTT_DBNAME=$dbname -e VTT_DBPORT=5432 -e VTT_DBHOST=$dbservername.postgres.database.azure.com -e VTT_LISTENHOST=0.0.0.0 -e VTT_LISTENPORT=3000 servian/techchallengeapp:latest 
docker ps 
docker cp -a updatedb.sh stc:/TechChallengeApp
docker exec stc /bin/sh -c ./updatedb.sh
docker rm -f stc
az postgres server firewall-rule delete --yes -g $rgname -s $dbservername -n updatedbIpDeleteme


ENTRYPOINT [ "./TechChallengeApp","updatedb","-s"]
docker login
docker build -t brian2nw/stc:latest .
docker push brian2nw/stc:latest
docker rm -f stc; docker run --name stc brian2nw/stc:latest