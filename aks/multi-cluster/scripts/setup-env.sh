SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
INFRA_PATH=$(realpath "${SCRIPT_DIR}/../infrastructure/infrastructure")

export RG=$(terraform -chdir=${INFRA_PATH} output -raw AKS_RESOURCE_GROUP)
export AKS=$(terraform -chdir=${INFRA_PATH} output -raw AKS_CLUSTER_NAME)

export AKS_CLUSTER_ID=$(az aks show -n ${AKS} -g ${RG} -o tsv --query id)