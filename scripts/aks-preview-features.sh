#!/bin/bash 

az extension add --name aks-preview
az extension update --name aks-preview

#Features Have Gone GA and no longer require preview flag
#HTTPProxyConfigPreview 
#MultiAgentpoolPreview
#EnablePodIdentityPreview
#RunCommandPreview
#AKS-OpenServiceMesh
#AKS-AzureKeyVaultSecretsProvider
#EnableOIDCIssuerPreview
#FleetResourcePreview
#AzureServiceMeshPreview
#EnableWorkloadIdentityPreview
#DisableLocalAccountsPreview
#AKS-AzureDefender
#AzureOverlayPreview
#AKS-PrometheusAddonPreview
#EnableImageCleanerPreview
#AKS-KedaPreview
#NodeOsUpgradeChannelPreview
#EnableBYOKOnEphemeralOSDiskPreview
#AKS-ExtensionManager
#AKS-Dapr
#AKS-AzurePolicyExternalData
#DisableSSHPreview

features=(
    "EnableAPIServerVnetIntegrationPreview"
    "EnableAzureDiskCSIDriverV2"
    "EnableMultipleStandardLoadBalancers"
    "AKSNodelessPreview"
    "CiliumDataplanePreview"
    "TrustedAccessPreview"
    "KubeletDisk"
    "KataVMIsolationPreview"
    "KataCcIsolationPreview"
    "NetworkObservabilityPreview"
    "EnableCloudControllerManager"
    "EnableImageIntegrityPreview"
    "KubeProxyConfigurationPreview"
    "NodeAutoProvisioningPreview"
    "NRGLockdownPreview"
    "IstioNativeSidecarModePreview"
    "SafeguardsPreview"
    "AutomaticSKUPreview"
    "AdvancedNetworkingPreview"
    "AzureLinuxV3Preview"
    "NetworkIsolatedClusterPreview"
    "AzureMonitorAppMonitoringPreview"
)

for feature in ${features[*]}
do
    az feature register --namespace Microsoft.ContainerService --name $feature
done 

watch -n 10 -g az feature list --namespace Microsoft.ContainerService -o table --query \"[?properties.state == \'Registering\']\"

az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.KubernetesConfiguration

az extension add --name k8s-extension
az extension add --name fleet
