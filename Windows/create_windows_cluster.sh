#!/bin/bash 

export NAME=$1
export WIN_PASSWORD=$2

RG_NAME='DevSub02_K8S01_RG'
NODEPOOL_RG_NAME='DevSub02_K8S01_RG_winnodes'
LINUX_NODE_POOL='lpool1'
WIN_NODE_POOL='wpool1'
SERVICE_CIDR='10.191.0.0/16'
DNS_IP='10.191.0.10'
SUBNET_ID='/subscriptions/bfafbd89-a2a3-43a5-af72-fb4ef0c514c1/resourceGroups/DevSub02_Network_RG/providers/Microsoft.Network/virtualNetworks/DevSub02-VNet-002/subnets/KubernetesWindows'
VER='1.17.7'

PUBLIC_IP=`curl -s http://checkip.amazonaws.com/`

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
    --ssh-key-value '~/.ssh/id_rsa.pub' \
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
