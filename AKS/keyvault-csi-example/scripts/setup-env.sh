SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
INFRA_PATH=$(realpath "${SCRIPT_DIR}/../infrastructure")

export RG=$(terraform -chdir=${INFRA_PATH} output -raw AKS_RESOURCE_GROUP)
export AKS=$(terraform -chdir=${INFRA_PATH} output -raw AKS_CLUSTER_NAME)
export APP_NAME=$(terraform -chdir=${INFRA_PATH} output -raw APP_NAME)
export ARM_WORKLOAD_APP_ID=$(terraform -chdir=${INFRA_PATH} output -raw ARM_WORKLOAD_APP_ID)
export ARM_TENANT_ID=$(terraform -chdir=${INFRA_PATH} output -raw ARM_TENANT_ID)