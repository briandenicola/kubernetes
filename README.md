# Overview

A set of example Kubernetes clusters with a focus on Azure AKS and CNCF projects.  Most of these examples require Terraform so requires a working knowledge of that tooling and how it is used with Azure/GCP. This repository also contains a few applications that can be used to demostrate various capabilities 

## Tooling
* [Terraform](https://developer.hashicorp.com/terraform/downloads)
* [Azure Cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Task](https://taskfile.dev/installation/)

# AKS
| Directory | Description |
|--------------- | --------------- |
| [Azure Backups](/aks/azure-backups/) | A demo of AKS Backups deployment|
| [Azure ML Extensions](/aks/azureml-extension/) | An example Azure ML Studio connectedt to an AKS cluster with the Azure Machine Learning extension added |
| [Basic](/aks/basic/) | An simple example AKS cluster for testing |
| [Premium](/aks/premium/) | A Quick and Dirty method to upgrade an AKS cluster to Premium Tier for Long Term Support|
| [Chaos Studio](/aks/chaos-studio/) | A set of ARM templates to onboard Chaos studio to an AKS cluster with a few experiments enabled  |
| [Cilium](./aks/cilium/) | An example AKS cluster with Cilium enabled|
| [Container Storage](./aks/container-storage/) | An example AKS cluster with Azure Managed Container Storage (Preview) created. |
| [HTTP Proxy](./aks/http-proxy/) | An example AKS cluster created with an HTTP Proxy.  Sample includes configurations for a basic Squid proxy running on an Azure VM |
| [Istio](./aks/istio/) | An example AKS cluster with Managed Service Mesh installed. _Outdated. Use [AKS with Istio](https://github.com/briandenicola/aks-with-istio) instead_|
| [Kata](./aks/kata/) |An example AKS cluster with AKS Isolated or Kata Containers (Preview) |
| [Keyvault CSI Example](./aks/keyvault-csi-example/) | An example AKS cluster with the Azure Keyvault CSI driver installed. Includes a demo app to mount the secrets |
| [Keyvault Traefik Demo](./aks//keyvault-csi-traefik-demo/) | An example AKS cluster with the Azure Keyvault CSI driver to mount a certificate for Traefik Ingress Controller |
| [Managed Prometheus](./aks/managed-prometheus/)| An example AKS cluster with Azure Managed Prometheus and Azure Managed Grafana |
| [Multi-Cluster Multi-Region](./aks/multi-cluster/infrastructure/multiregion-demo) | An example AKS Fleet Manager for muliple regions|
| [Multi-Cluster Patching](./aks/multi-cluster/infrastructure/patch-demo) | An example AKS Fleet Manager for patch managment|
| [Node Auto Provisioner](./aks/node-autoprovisioner) | An example Karpenter with AKS|
| [Proximity Groups](./aks/proximity-groups/)| An example AKS cluster deployed to a single AZ in an Azure region then grouped closely within the datacenter using Proximity Groups |
| [SPN Auth](./aks/spn-auth-example) | An example how to authenticate to an AKS cluster using Service Principals. _Outdated_ |
| [Storage Class Removal](./aks/storageclass-removal/) | An example how to remove storage classes from an AKS cluster. _Outdated_ |
| [Windows 2022](./aks/windows2022/) | An example AKS cluster with Windows 2022 node pools |
| [Dapr](./aks/dapr/) | An example AKS cluster with Dapr Extension installed |

# Container Apps
| Directory | Description |
|--------------- | --------------- |
| [Basic](./container-apps/basic/) | A basic Container App Environment |
| [Jobs](./container-apps/jobs) | A Container App Environment for jobs - TBD |
| [NAT](./container-apps/nat) | An internal Container App Environment with a NAT Gateway for Egress control |
| [Workload Profile](./container-apps/workloadprofile) | A workload profile Container App Environment with an Azure Firewall for egress control |
| [Workload Profile - Consumption](./container-apps/workloadprofile-consumptiononly) | A workload profile Container App Environment with an Azure Firewall for egress control using Consumption plan only |

# GKE
| Directory | Description |
|--------------- | --------------- |
| Basic | A simple GKE cluster for testing and comparisons only. |

# Demo Apps
* eshop - A sample application from Microsoft to demonstrate various Azure services 
* httpbin - A simple web application to test various HTTP calls (http://httpbin.org/)
* mssql - An example on how to deploy SQL Server in an Always On configuration _Outdated_
* nodejs - A very basic Nodejs API container
* otel-prometheus - An example app using Open Telemetry to export metrics to Prometheus 

# Kubernetes Specific 
* Namespace - Examples on Namespace configs
* Network Policies - Example Network policies 
* Pods - Example pods
* Roles - Examples using Kubernetes RBAC
* Windows - Window containers examples
