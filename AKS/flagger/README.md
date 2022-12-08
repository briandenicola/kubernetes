# Overview

This repository are my notes and learnings on Flagger. It is simple deployment of [Flagger's Canary Rollout](https://fluxcd.io/flagger/tutorials/istio-progressive-delivery/) with Istio on AKS. It uses the AKS [Flux](https://fluxcd.io/flux/) extension to deploy Istio, Flagger and the Flagger's example application. 

Flagger is progressive delivery tool that automates the release process for applications running on Kubernetes. It leverages Prometheus metrics for success analysis, and a Service Mesh (Istio in this example) to migrate traffic between application revisions.

This example can be used with Github CodeSpaces. Codespaces will configure a developer environment with all required tooling. 

# Prerequisites 
* Azure subscription
* az cli
* Terraform 
* flux

# Demostration 
## Envrionment Setup 
```bash
  az login 
  make infrastructure 
```

## First Validation
```bash
  make check
```

## Update Pod Image
```bash 
  make edit
  make check #Run multiple times to watch rollout
```
### Expected Outcome
```
  kubectl -n test describe canary/podinfo

Status:
  Canary Weight:         0
  Failed Checks:         0
  Phase:                 Succeeded
Events:
  Type     Reason  Age   From     Message
  ----     ------  ----  ----     -------
  Normal   Synced  3m    flagger  New revision detected podinfo.test
  Normal   Synced  3m    flagger  Scaling up podinfo.test
  Warning  Synced  3m    flagger  Waiting for podinfo.test rollout to finish: 0 of 1 updated replicas are available
  Normal   Synced  3m    flagger  Advance podinfo.test canary weight 5
  Normal   Synced  3m    flagger  Advance podinfo.test canary weight 10
  Normal   Synced  3m    flagger  Advance podinfo.test canary weight 15
  Normal   Synced  2m    flagger  Advance podinfo.test canary weight 20
  Normal   Synced  2m    flagger  Advance podinfo.test canary weight 25
  Normal   Synced  1m    flagger  Advance podinfo.test canary weight 30
  Normal   Synced  1m    flagger  Advance podinfo.test canary weight 35
  Normal   Synced  55s   flagger  Advance podinfo.test canary weight 40
  Normal   Synced  45s   flagger  Advance podinfo.test canary weight 45
  Normal   Synced  35s   flagger  Advance podinfo.test canary weight 50
  Normal   Synced  25s   flagger  Copying podinfo.test template spec to podinfo-primary.test
  Warning  Synced  15s   flagger  Waiting for podinfo-primary.test rollout to finish: 1 of 2 updated replicas are available
  Normal   Synced  5s    flagger  Promotion completed! Scaling down podinfo.test
```

## Clean Up Azure
```bash
  make clean
```

# Notes
* [Flagger Webhooks](https://fluxcd.io/flagger/usage/webhooks/) are used to generate enough traffic for it to decide when and how to migrate from the primary to the canary release
* When a Canary Resoruce is created in Kubernetes, Flagger will create a primary and target deployment. 
  * The primary deployment is considered the stable release of your app, by default all traffic is routed to this version and the target deployment is scaled to zero. 
  * Flagger will detect changes to the target deployment (including secrets and configmaps) and will perform a canary analysis before promoting the new version as primary.
* Flagger can use HPA Autoscaler to help with analysis.  The autoscaler reference is optional, when specified, Flagger will pause the traffic increase while the target and primary deployments are scaled up or down. 
* [Deployment Strategies](https://fluxcd.io/flagger/usage/deployment-strategies/)