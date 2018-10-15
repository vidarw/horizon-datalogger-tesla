config ?= default.env
include $(config)
export $(shell sed 's/=.*//' $(config))

.azure:
	az account set --subscription $(azure_subscription_id) || az login && az account set --subscription $(azure_subscription_id)

.terraform:
	$(eval terraform_access_key := $(shell az storage account keys list --account-name $(terraform_storage_account) --resource-group $(terraform_storage_group) --output json | jq .[0].value -r))
	$(eval azure_client_id := $(shell az keyvault secret show --name $(key_vault_client_id_name) --vault-name $(key_vault_name) --subscription $(azure_subscription_id) | jq .value -r))
	$(eval azure_client_secret := $(shell az keyvault secret show --name $(key_vault_client_secret_name) --vault-name $(key_vault_name) --subscription $(azure_subscription_id) | jq .value -r))

default: terraform-init terraform-plan

terraform-init: .azure .terraform
	cd ./terraform; terraform init -backend-config="./environments/$(environment_name)/backend.tfvars" -backend-config="storage_account_name=$(terraform_storage_account)" -backend-config="access_key=$(terraform_access_key)" -reconfigure

terraform-plan: .azure .terraform
	cd ./terraform; terraform plan -var="azure_tenant_id=$(azure_tenant_id)" -var="azure_subscription_id=$(azure_subscription_id)"  -var="azure_client_id=$(azure_client_id)" -var="azure_client_secret=$(azure_client_secret)" -var-file="./environments/$(environment_name)/$(environment_name).tfvars" -out $(environment_name).tfplan

terraform-apply:
	cd ./terraform; terraform apply $(environment_name).tfplan

terraform-destroy: .terraform
	cd ./terraform; terraform destroy -var="azure_tenant_id=$(azure_tenant_id)" -var="azure_subscription_id=$(azure_subscription_id)"  -var="azure_client_id=$(azure_client_id)" -var="azure_client_secret=$(azure_client_secret)" -var-file="./environments/$(environment_name)/$(environment_name).tfvars"