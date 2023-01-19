#!/bin/bash 

export NAME=$1

RG_NAME='aks_http_proxy_test'
CORE_SUB_ID=''
DNS_RG_NAME=''
NETWORK_RG='DevSub02_Network_RG'
NETWORK_NAME='DevSub02-Vnet-Sandbox-002'
NODEPOOL_RG_NAME=DevSub02_AKS_${NAME}_nodes_RG
LINUX_NODE_POOL='default'
SERVICE_CIDR='10.191.0.0/16'
DNS_IP='10.191.0.10'
VER='1.23.3'

SUB_ID=`az account show -o tsv --query id`

SUBNET_ID=/subscriptions/${SUB_ID}/resourceGroups/${NETWORK_RG}/providers/Microsoft.Network/virtualNetworks/${NETWORK_NAME}/subnets/kubernetesdev
DNS_ZONE=/subscriptions/${CORE_SUB_ID}/resourceGroups/${DNS_RG_NAME}/providers/Microsoft.Network/privateDnsZones/privatelink.southcentralus.azmk8s.io
CLUSTER_IDENTITY=/subscriptions/${SUB_ID}/resourceGroups/${RG_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/k8s-cluster-identity
KUBELET_IDENTITY=/subscriptions/${SUB_ID}/resourceGroups/${RG_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/k8s-kubelet-identity


az aks create \
    --resource-group ${RG_NAME} \
    --name ${NAME} \
    --enable-private-cluster \
    --node-count 3 \
    --node-resource-group ${NODEPOOL_RG_NAME} \
    --max-pods 30 \
    --nodepool-name ${LINUX_NODE_POOL} \
    --network-plugin azure \
    --vnet-subnet-id ${SUBNET_ID} \
    --generate-ssh-keys \
    --kubernetes-version ${VER} \
    --service-cidr ${SERVICE_CIDR} \
    --network-policy azure \
    --dns-service-ip ${DNS_IP} \
    --enable-cluster-autoscaler \
    --min-count 1 \
    --max-count 3 \
    --auto-upgrade-channel stable \
    --load-balancer-sku standard \
    --uptime-sla \
    --enable-managed-identity \
    --http-proxy-config proxy.json \
    --fqdn-subdomain ${NAME} \
    --disable-public-fqdn \
    --private-dns-zone  ${DNS_ZONE} \
    --outbound-type userDefinedRouting \
    --os-sku CBLMariner \
    --assign-identity ${CLUSTER_IDENTITY} \
    --assign-kubelet-identity ${KUBELET_IDENTITY} 
