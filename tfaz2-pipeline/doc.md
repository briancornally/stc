
# Assessment criteria
- deploys to an empty cloud subscription with no existing infrastructure in place
- start from a cloned git repo
- pre-requisites documented in the following section
- deploy code contained within this GitHub repository
- deploys via terraform automated process
- entirely infrastructure as code

# Pre requisites for your deployment solution
- terraform init -backend-config=backend-config.txt
- keyvault soft delete is now enabled by default on azure. to remove keyvault use script: tfaz0-be-local/rm-kv.sh
    - https://docs.microsoft.com/en-us/azure/key-vault/general/soft-delete-change
- variables
    - a single terraform input variable is expected. You can declare as an environment variable or be prompted for a value.  
        - export TF_VAR_dbpassword=123456789qwertyuipz_
    - all other variables have defaults
- expect azcli installed
    - https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

# High level architectural overview of your deployment 
- directory: tfaz0-be-local - deploy azure storage backend
- directory: tfaz1-kv-local - deploy keyvault and populate with dbpasswd
- directory: tfaz2-pipeline - deploy solution cli or pipeline

# Process instructions for provisioning your solution
## Deploy terraform backend on azure storage
- run from local only as normally it is a precursor to pipeline
- possible future developments: 
    - pipeline 

```
cd tfaz0-be-local
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

## Deploy keyvault and populate with dbpasswd
- run from local only as it is a precursor to pipeline. 
- sample workspace values: dev|accp|prod. optional as if unspecified will be "default"
- possible future developments: 
    - pipeline generated random password and stores password in new keyvault

```
cd tfaz1-kv-local
./workspacetest.sh dev
terraform init
terraform plan -out tfplan
terraform apply tfplan
```
- sample output
```
azurerm_resource_group.kv: Creating...
azurerm_resource_group.kv: Creation complete after 1s [id=/subscriptions/c568096a-90af-455c-91d0-31314d3fbbf5/resourceGroups/dev-app1-kv]
azurerm_key_vault.kv: Creating...
azurerm_key_vault.kv: Still creating... [10s elapsed]
...
azurerm_key_vault.kv: Still creating... [2m0s elapsed]
azurerm_key_vault.kv: Creation complete after 2m7s [id=/subscriptions/c568096a-90af-455c-91d0-31314d3fbbf5/resourceGroups/dev-app1-kv/providers/Microsoft.KeyVault/vaults/dev-app1-kv]
azurerm_key_vault_secret.kvdbpassword: Creating...
azurerm_key_vault_secret.kvdbpassword: Creation complete after 3s [id=https://dev-app1-kv.vault.azure.net/secrets/dbpassword/18cc3627cf9744d396de6ef550c4a133]

Apply complete! Resources: 3 added, 0 changed, 1 destroyed.
```

## deploy solution 
- run from cli or pipeline
- terraform backend on azure storage can be shared
- sample workspace values: dev|accp|prod. optional as if unspecified will be "default"
```
cd tfaz2-pipeline
cp ../tfaz0-be-local/backend-config.txt .
./workspacetest.sh dev (optional)
terraform init -backend-config=backend-config.txt
terraform plan -out tfplan
terraform apply tfplan
```

# Architecture
## Network
-

## Database
GP_S_Gen5_1 is cheapest
- https://docs.microsoft.com/en-us/azure/azure-sql/database/resource-limits-vcore-single-databases 

### ssl_enforcement_enabled      = false
go app does not support ssl

Azure Database for PostgreSQL 
- flexible, General Purpose, HA, locally redundant, 2 availability zones, private access, D2s_v3, 2 vCores, 8 GiB RAM, 32 GiB storage  229.45 CAD / month
- single server (includes HA) GeneralPurpose, Gen5, 2 vCores, 5 GB Storage 247 CAD / month

## App Service

### Scaling

