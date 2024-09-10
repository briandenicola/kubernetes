#!/bin/bash

# this runs each time the container starts

echo "$(date)    post-start start" >> ~/status
sudo az aks install-cli
sudo az extension add --name application-insights -y
sudo az extension add --name aks-preview -y

git clone https://github.com/briandenicola/eshop.git /workspaces/eshop

echo "$(date)    post-start complete" >> ~/status
