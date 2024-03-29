#!/bin/bash

# Set the GitHub Config URL and Secret
while (( "$#" )); do
  case "$1" in
    -u)
      GITHUB_CONFIG_URL=$2
      shift 2
      ;;
    -s)
      GITHUB_PAT=$2
      shift 2
      ;;
    -h|--help)
      echo "Usage: ./setup.sh -u {GITHUB_CONFIG_URL} -p {GITHUB_PAT}
        -u: The Github Repository URL
        -p: The Github Personal Access Token (PAT) to access the GitHub Repository
      "
      echo "See https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/deploying-runner-scale-sets-with-actions-runner-controller#using-docker-in-docker-mode for more information"
      exit 0
      ;;
    --) 
      shift
      break
      ;;
    -*|--*=) 
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "${GITHUB_CONFIG_URL}" ]]; then
  echo "Error: Missing required flag -u" >&2
  exit -1
fi 

if [[ -z "${GITHUB_PAT}" ]]; then
  echo "Error: Missing required flag -p" >&2
  exit -1
fi 

# Deploy the ARC Controller
NAMESPACE="arc-systems"
helm install arc \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller

# Deploy the ARC Runner
INSTALLATION_NAME="arc-runner-set"                                  
NAMESPACE="arc-runners"
helm upgrade -i "${INSTALLATION_NAME}" \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --set githubConfigUrl="${GITHUB_CONFIG_URL}" \
    --set githubConfigSecret.github_token="${GITHUB_PAT}" \
    --values ~/working/arc/values.yaml \
   oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set 