export RG=$(terraform -chdir=./infrastructure output -raw AKS_RESOURCE_GROUP)
export AKS_CONTROLPLANE_CLUSTER=$(terraform -chdir=./infrastructure output -raw CONTROLPLANE_AKS_CLUSTER_NAME)
export AKS_SUBSCRIPTION_ID=$(terraform -chdir=./infrastructure output -raw AKS_SUBSCRIPTION_ID)