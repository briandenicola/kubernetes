# ⚠️EXPERIMENTAL ⚠️

# Overview

This repository is a demonstration of AKS with KubeVela from a DevContainers. 

* [KubeVela](https://kubevela.io/docs/) is a modern software delivery control plane that strides to make deploying and operating applications across today's multi-cloud environments easier, faster and more reliable.  
* [DevContainers](https://containers.dev/) build consistent developer environments

# Quicksteps
```bash
    az login --scope https://graph.microsoft.com/.default
    make environment
```

# Sample KubeVela commands
```
    vela addon enable velaux
    vela addon enable fluxcd
    vela addon enable flink-kubernetes-operator   
    vela addon enable cert-manager
    vela addon enable ingrexx-nginx
    vela cluster list
    
    vela env init prod --namespace prod
    vela up -f https://kubevela.net/example/applications/first-app.yaml
    vela status first-vela-app
    vela port-forward first-vela-app 8000:8000
    vela workflow resume first-vela-app
    vela port-forward addon-velaux -n vela-system

    vela show helm

```
  
# Backlog
- [ ] Learn KubeVela
