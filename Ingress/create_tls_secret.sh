#!/bin/bash 

#helm upgrade traefik stable/traefik --set ssl.insecureSkipVerify=true --set ssl.enabled=true --set rbac.enabled=true
#acme.sh --issue -d *.bjdazure.tech --yes-I-know-dns-manual-mode-enough-go-ahead-please --dns 

kubectl create secret tls traefik-apim-cert --key=wildcard.bjdazure.tech.key --cert=wildcard.bjdazure.tech.cer