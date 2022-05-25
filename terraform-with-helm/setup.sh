export ARM_USE_MSI=true 
export ARM_TENANT_ID=$1
export ARM_SUBSCRIPTION_ID=$2

az login --identity 
terraform init 
terraform apply -auto-approve 