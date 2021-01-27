az account show

export TF_VAR_resource_group_suffix=app1

rm -rf .terraform .terraform.lock.hcl

terraform init; 
terraform init; terraform plan -out tf2.tfplan
terraform plan -out tf2.tfplan
terraform apply 
terraform plan; terraform apply -auto-approve tf2.tfplan
terraform init; terraform plan -out tf2.tfplan; terraform apply -auto-approve tf2.tfplan
