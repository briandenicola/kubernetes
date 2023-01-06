# Overview
This is a quick demo of AKS Fleet Manager load balancing requests acrsos the two clusters deployed to two different Azure regions.

# Infrastructure 

# Fleet Manager 
```bash
az group --name fleet_rg --location southcentralus
az fleet create --name fleet01 --resource-group fleet_rg
az fleet get-credentials --name fleet01 --resource-group fleet_rg --file fleet
sed -i s/devicecode/azurecli/g fleet
```

## Cluster - South Central
```bash
terraform -chdir=./infrastructure workspace new sc
terraform -chdir=./infrastructure init
terraform -chdir=./infrastructure apply -auto-approve -var "region=southcentralus"
source ./scripts/setup-env.sh
az aks get-credentials -g ${RG} -n ${AKS} --overwrite-existing --file=aks-southcentral
sed -i s/devicecode/azurecli/g aks-southcentral
az fleet member create --fleet-name fleet01 --member-cluster-id ${AKS_CLUSTER_ID} --name ${AKS} --resource-group ${RG} --no-wait
```

## Cluster - West US 3
```bash
terraform -chdir=./infrastructure workspace new west
terraform -chdir=./infrastructure init
terraform -chdir=./infrastructure apply -auto-approve -var "region=westus3"
source ./scripts/setup-env.sh
az aks get-credentials -g ${RG} -n ${AKS} --overwrite-existing --file=aks-west
sed -i s/devicecode/azurecli/g aks-west
az fleet member create --fleet-name fleet01 --member-cluster-id ${AKS_CLUSTER_ID} --name ${AKS} --resource-group ${RG} --no-wait
```

# Deployment
## Fleet Manager
```bash
KUBECONFIG=fleet kubectl apply -f fleet-app-deployment.yaml
KUBECONFIG=fleet kubectl apply -f fleet-app-export-service.yaml
KUBECONFIG=fleet kubectl apply -f fleet-cluster-placement.yaml
```
## Primary Cluster
```bash
KUBECONFIG=aks-southcentral kubectl apply -f cluster-app-multi-cluster-service.yaml
```

# Test
## Cluster Configuration
```bash
KUBECONFIG=fleet kubectl get clusterresourceplacements

KUBECONFIG=aks-southcentral kubectl get multiclusterservice httpbin --namespace app
KUBECONFIG=aks-southcentral kubectl get serviceexport httpbin --namespace app
KUBECONFIG=aks-southcentral kubectl get pods -o wide

KUBECONFIG=aks-west kubectl get serviceexport httpbin --namespace app
KUBECONFIG=aks-southcentral kubectl get pods -o wide
```

## Application Load Balancing
The host name returned by the command below should bounce between the two clusters
```bash 
    curl -s http://${IP_ADDR_FROM_MULTI_CLUSTER_SERVICE}:8080/api/os | jq .Host
    curl -s http://${IP_ADDR_FROM_MULTI_CLUSTER_SERVICE}:8080/api/os | jq .Host
    curl -s http://${IP_ADDR_FROM_MULTI_CLUSTER_SERVICE}:8080/api/os | jq .Host
    curl -s http://${IP_ADDR_FROM_MULTI_CLUSTER_SERVICE}:8080/api/os | jq .Host
    curl -s http://${IP_ADDR_FROM_MULTI_CLUSTER_SERVICE}:8080/api/os | jq .Host
```
