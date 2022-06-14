#!/bin/bash 

export CLUSTER_NAME=$1

CLUSTER_RG=${CLUSTER_NAME}_RG
CLUSTER_NODES_RG=${CLUSTER_NAME}_nodes_RG

LINUX_NODE_POOL='default'

az group create -n ${CLUSTER_RG} -l southcentralus

IP=`curl -s http://checkip.amazonaws.com/`

az aks create \
    --resource-group ${CLUSTER_RG} \
    --name ${CLUSTER_NAME} \
    --node-count 3 \
    --node-resource-group ${CLUSTER_NODES_RG} \
    --max-pods 30 \
    --nodepool-name ${LINUX_NODE_POOL} \
    --network-plugin kubenet \
    --no-ssh-key \
    --enable-cluster-autoscaler \
    --min-count 1 \
    --max-count 3 \
    --auto-upgrade-channel stable \
    --load-balancer-sku standard \
    --uptime-sla \
    --enable-azure-rbac \
    --enable-aad \
    --enable-oidc-issuer \
    --enable-pod-identity \
    --enable-pod-identity-with-kubenet \
    --disable-local-accounts \
    --enable-managed-identity \
    --os-sku CBLMariner \
    --api-server-authorized-ip-ranges $IP/32