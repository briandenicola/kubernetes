# ⚠️EXPERIMENTAL ⚠️

# Overview

This repository is a demonstration of using Crossplane with KubeVela in Azure on AKS.

* [Crossplane](https://www.crossplane.io/) is an open source Kubernetes add-on that transforms your cluster into a universal control plane. Crossplane enables platform teams to assemble infrastructure from multiple vendors, and expose higher level self-service APIs for application teams to consume, without having to write any code.
* [KubeVela](https://kubevela.io/docs/) is a modern software delivery control plane that strides to make deploying and operating applications across today's multi-cloud environments easier, faster and more reliable.  
* [Crossplane with Kubevela](https://kubevela.io/docs/platform-engineers/crossplane/)

# Quicksteps
```bash
    az login --scope https://graph.microsoft.com/.default
    task up
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

# Additional References
* http://kubevela.net/docs/developers/references/devex/faq
* https://github.com/kubevela/terraform-controller

# Backlog
- [ ] Learn Crossplane
- [ ] Learn KubeVela
