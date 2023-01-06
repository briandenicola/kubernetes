#!/bin/bash

export IDENTITY=$1
export RGNAME=$2
export AKSNAME=$3

RESOURCEID=`az identity show --name $IDENTITY --resource-group $RGNAME --query id -o tsv`
az aks pod-identity add --resource-group $RGNAME --cluster-name $AKSNAME --namespace default --name $IDENTITY --identity-resource-id $RESOURCEID