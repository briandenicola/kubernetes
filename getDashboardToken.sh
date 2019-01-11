#!/bin/bash

dashboardSecret=$(kubectl get serviceaccount -n kube-system kubernetes-dashboard -o json | jq ".secrets[0].name" | sed 's/"//g')
echo Token for $dashboardSecret: 
kubectl -n kube-system get secret $dashboardSecret -o json | jq .data.token |  sed 's/"//g' | base64 -d
echo