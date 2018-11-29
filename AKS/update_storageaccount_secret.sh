#!/bin/bash

export k8s=$1
export rg=$2
export storageacct=$3

az login

nrg=$(az aks show --resource-group $rg --name $k8s --query nodeResourceGroup -o tsv)
key=$(az storage account keys list  -n $storageacct -g $nrg -o json --query "[0].value" | sed -e 's/^"//' -e 's/"$//')
secret_name=$(kubectl get secret -o json | jq ".items[] | select(.metadata.name | contains(\"$storageacct\")) | .metadata.name" | sed -e 's/^"//' -e 's/"$//')

kubectl delete secret $secret_name
kubectl create secret generic $secret_name --from-literal=azurestorageaccountname=$storageacct --from-literal=azurestorageaccountkey=$key