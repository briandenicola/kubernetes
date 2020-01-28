#/bin/bash

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

wget https://get.helm.sh/helm-v2.15.2-linux-amd64.tar.gz
    
tar zxvf helm-v2.15.2-linux-amd64.tar.gz  
cd linux-amd64
./helm init --service-account tiller --wait
./helm upgrade traefik stable/traefik --set rbac.enabled=true --install

kubectl apply -f https://raw.githubusercontent.com/Azure/kubernetes-keyvault-flexvol/master/deployment/kv-flexvol-installer.yaml
kubectl apply -f https://raw.githubusercontent.com/Azure/aad-pod-identity/master/deploy/infra/deployment-rbac.yaml