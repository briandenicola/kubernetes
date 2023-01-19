#!/bin/bash 

export NAME=$1
export LOCATION=$2
export WIN_PASSWORD=$3
export SUBNET_ID=$4

RG_NAME=${NAME}_RG
NODEPOOL_RG_NAME=${NAME}_Nodes_RG
LINUX_NODE_POOL='lpool1'
WIN_NODE_POOL='wpool1'
SERVICE_CIDR='10.191.0.0/16'
DNS_IP='10.191.0.10'

VER='1.22'

PUBLIC_IP=`curl -s http://checkip.amazonaws.com/`

az group create -n ${NAME} -location ${LOCATION}

az aks create \
    --resource-group $RG_NAME \
    --name $NAME \
    --node-count 1 \
    --node-resource-group $NODEPOOL_RG_NAME \
    --enable-addons monitoring \
    --windows-admin-password $WIN_PASSWORD \
    --windows-admin-username manager \
    --max-pods 30 \
    --nodepool-name $LINUX_NODE_POOL \
    --network-plugin azure \
    --vnet-subnet-id $SUBNET_ID \
    --kubernetes-version $VER \
    --service-cidr $SERVICE_CIDR \
    --dns-service-ip $DNS_IP \
    --enable-cluster-autoscaler \
    --min-count 1 \
    --max-count 3 \
    --load-balancer-sku Standard \
    --uptime-sla \
    --enable-managed-identity \
    --api-server-authorized-ip-ranges $PUBLIC_IP/32 

az aks nodepool add \
    --resource-group $RG_NAME \
    --cluster-name $NAME \
    --os-type Windows \
    --name $WIN_NODE_POOL \
    --node-count 3 \
    --kubernetes-version $VER
