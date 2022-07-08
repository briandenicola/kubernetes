param(
    [Parameter(Mandatory=$true)]
    [string] $FeatureName = "AKSWindows2022Preview", 
    [Parameter(Mandatory=$true)]
    [string] $NameSpace = "Microsoft.ContainerService"
)

az feature register --namespace $NameSpace --name $FeatureName

function Get-FeatureState 
{
    param(
        [string] $FeatureName
    )
    return (az feature list -o tsv --query "[?contains(name,'$FeatureName')].`{State:properties.state}")
}

while ( (Get-FeatureState -FeatureName "$NameSpace/$FeatureName") -eq "Registering" ) {
    Write-Host "." -NoNewline
    Start-Sleep -Seconds 60
}

az provider register --namespace Microsoft.ContainerService