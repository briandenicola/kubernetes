# ⚠️EXPERIMENTAL ⚠️

# Overview

This repository is a demonstration of using Crossplane with KubeVela in Azure on AKS.

* [Crossplane](https://www.crossplane.io/) is an open source Kubernetes add-on that transforms your cluster into a universal control plane. Crossplane enables platform teams to assemble infrastructure from multiple vendors, and expose higher level self-service APIs for application teams to consume, without having to write any code.
* [KubeVela](https://kubevela.io/docs/) is a modern software delivery control plane that strides to make deploying and operating applications across today's multi-cloud environments easier, faster and more reliable.  
* [Crossplane with Kubevela](https://kubevela.io/docs/platform-engineers/crossplane/)

# Prerequisites 
* Azure Subscription
* [Azure Cli](https://github.com/briandenicola/tooling/blob/main/azure-cli.sh)
* [Terraform](https://github.com/briandenicola/tooling/blob/main/terraform.sh)
* [Task](https://github.com/briandenicola/tooling/blob/main/task.sh)
* [Vela Cli](https://github.com/briandenicola/tooling/blob/main/kubevela.sh)
* [Crossplane Cli](https://github.com/briandenicola/tooling/blob/main/crossplane.sh)

# Quicksteps
```bash
    az login --scope https://graph.microsoft.com/.default
    task up
```

# Sample Crossplane Setup / Commands
```bash
    source ./scripts/setup-env.sh
    kubectl crossplane install configuration registry.upbound.io/xp/getting-started-with-azure:v1.10.2
    az ad sp create-for-rbac --role Contributor --scopes /subscriptions/${AKS_SUBSCRIPTION_ID} > "creds.json"
    kubectl create secret generic azure-creds -n crossplane-system --from-file=creds=./creds.json
    cat << EOF | kubectl apply -f -
        apiVersion: azure.crossplane.io/v1beta1
        kind: ProviderConfig
        metadata:
            name: default
        spec:
            credentials:
                source: Secret
                secretRef:
                    namespace: crossplane-system
                    name: azure-creds
                    key: creds
    EOF 
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
* https://docs.crossplane.io/v1.10/cloud-providers/azure/azure-provider/

# Backlog
- [ ] Learn Crossplane
- [ ] Learn KubeVela
