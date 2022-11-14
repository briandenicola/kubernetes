#!/bin/bash 

export CLUSTER_NAME=$1
export LOCATION=$2

CLUSTER_RG=${CLUSTER_NAME}_RG
CLUSTER_NODES_RG=${CLUSTER_NAME}_nodes_RG

VNET_RG="Apps03_Network_RG"
VNET_NAME="DevSub03-Vnet-003"

LINUX_NODE_POOL='default'

az network vnet create -g ${VNET_RG} --location ${LOCATION} --name ${VNET_NAME} --address-prefixes 10.18.0.0/16 -o none
SUBNET_ID=$(az network vnet subnet create -g ${VNET_RG} --vnet-name ${VNET_NAME} --name nodesubnet --address-prefix 10.18.7.0/24 -o tsv --query id)

az group create -n ${CLUSTER_RG} -l ${LOCATION}

IP=`curl -s http://checkip.amazonaws.com/`

az aks create \
    --resource-group ${CLUSTER_RG} \
    --name ${CLUSTER_NAME} \
    --node-count 3 \
    --node-resource-group ${CLUSTER_NODES_RG} \
    --max-pods 30 \
    --nodepool-name ${LINUX_NODE_POOL} \
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
    --disable-local-accounts \
    --enable-managed-identity \
    --os-sku CBLMariner \
    --network-plugin azure \
    --network-plugin-mode overlay \
    --pod-cidr 100.76.0.0/16 \
    --service-cidr 100.66.0.0/16 \
    --dns-service-ip 100.66.0.10 \
    --vnet-subnet-id ${SUBNET_ID} \
    --api-server-authorized-ip-ranges $IP/32
