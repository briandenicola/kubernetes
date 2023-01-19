export RG=$(terraform -chdir=./infrastructure output -raw AKS_RESOURCE_GROUP)
export AKS=$(terraform -chdir=./infrastructure output -raw AKS_CLUSTER_NAME)
export AKS_CLUSTER_ID=$(terraform -chdir=./infrastructure output -raw AKS_CLUSTER_ID)