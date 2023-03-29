#!/bin/bash

while (( "$#" )); do
  case "$1" in
    -r|--region)
      LOCATION=$2
      shift 2
      ;;
    -n|--cluster-name)
      CLUSTER_NAME=$2
      shift 2
      ;;
    -g|--resource-group)
      RESOURCE_GROUP=$2
      shift 2
      ;;
    -h|--help)
      echo "Usage: ./onboard-target.sh -r {region} -n {aks cluster} -g {aks resource group}
      "
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

echo Installing Chaos Mesh on ${CLUSTER_NAME} in ${RESOURCE_GROUP}
az aks get-credentials -g ${RESOURCE_GROUP} -n ${CLUSTER_NAME}
helm repo add chaos-mesh https://charts.chaos-mesh.org
helm repo update
kubectl create ns chaos-testing
helm install chaos-mesh chaos-mesh/chaos-mesh --namespace=chaos-testing --set chaosDaemon.runtime=containerd --set chaosDaemon.socketPath=/run/containerd/containerd.sock

echo Creating Chaos Targets in ${RESOURCE_GROUP}
az group deployment create -n Chaos -g ${RESOURCE_GROUP} --template-file ./azuredeploy.deployment.json --parameters "{ \"resourceName\": { \"value\": \"${CLUSTER_NAME}\" }, \"location\": { \"value\": \"${LOCATION}\" } }"