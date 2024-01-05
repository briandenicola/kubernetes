# Overview
This is a  demo of AKS Fleet Manager. 

It covers the following:
* SDLC Patch management
* Load balancing requests across the clusters _Pending_

Each demo creates the Fleet Manager, AKS Clusters and joins the clusters as members of the Fleet Manager.

# Patching Demo infrastructure 
## Infrastructure Creation
```bash
task patch:up -- southcentralus
```

## SDLC Patching Steps
* [Official Documentation](https://learn.microsoft.com/en-us/azure/kubernetes-fleet/update-orchestration?tabs=azure-portal)
* Detail Steps (TBD) but will continues in the Portal

# Multi-region Demo 
## Infrastructure Creation
__Note__: The code will create AKS clusters in the following regions: South Central US and West US3. You can change the regions by editing the `./infrastructure/multiregion-demo/regions.tfvar` file.

```bash
task multiregion:up -- southcentralus #Region for the FLeet Manager HUB
task multiregion:save-creds
```

## Appliation Deployment
```bash
KUBECONFIG=fleet kubectl apply -f ./deploy/fleet-app-deployment.yaml
KUBECONFIG=fleet kubectl apply -f ./deploy/fleet-app-export-service.yaml
KUBECONFIG=fleet kubectl apply -f ./deploy/fleet-cluster-placement.yaml
```
## Primary Cluster
```bash
KUBECONFIG={primary} kubectl apply -f ./deploy/cluster-app-multi-cluster-service.yaml
```

# Test
## Cluster Configuration
```bash
KUBECONFIG=fleet kubectl get clusterresourceplacements

KUBECONFIG={primary} kubectl get multiclusterservice httpbin --namespace app
KUBECONFIG={primary} kubectl get serviceexport httpbin --namespace app
KUBECONFIG={primary} kubectl get serviceimport httpbin --namespace app
KUBECONFIG={primary} kubectl get pods -o wide --namespace app

KUBECONFIG={secondary} kubectl get serviceexport httpbin --namespace app
KUBECONFIG={secondary} kubectl get pods -o wide --namespace app
```

## Application Load Balancing
The host name returned by the command below should bounce between the two clusters
```bash 
export MCS_IP=$(KUBECONFIG=primary kubectl -n app get multiclusterservice httpbin  -o json | jq '.status.loadBalancer.ingress[0].ip' -r)
curl -s http://${MCS_IP}:8080/api/os | jq .Host
curl -s http://${MCS_IP}:8080/api/os | jq .Host
curl -s http://${MCS_IP}:8080/api/os | jq .Host
curl -s http://${MCS_IP}:8080/api/os | jq .Host
curl -s http://${MCS_IP}:8080/api/os | jq .Host
```