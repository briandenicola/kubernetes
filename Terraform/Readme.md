# Overview
Documenting how to create an AKS clusing using Azure DevOps Release Pipeline with Terraforms.
The tfstate and plan files will be stored in Azure Blob Storage

# Steps
## PowerShell Script
### Command:
```
  $RGName = "AKS_Terraforms_RG"
  Write-Host "##vso[task.setvariable variable=ResourceGroupName]$RGName"
   
  $PlanFile = "aks.plan.{0}-{1}" -f $(Get-Date).ToString("yyyyMMdd"), [System.Guid]::NewGuid().ToString("N")
  Write-Host "##vso[task.setvariable variable=plan_file]$PlanFile"
```

## Terraform Init 
### Source:  
  ```
  $(System.DefaultWorkingDirectory)/_Kubernetes - Terraforms Build/drop
  ```
### Command: 
  ```
  terraform init  -backend=true -backend-config="access_key=$(access_key)"
  ```
### Notes
* Init file stored in plans container on bjdterraform001 account in DevSub02_Storage_RG

## Terraform Plan
### Source:  
  ```
  $(System.DefaultWorkingDirectory)/_Kubernetes - Terraforms Build/drop
  ```
### Command: 
  ```
  terraform plan -out="$(plan_file)" -var "resource_group_name=$(ResourceGroupName)" -var "client_secret=$(client_secret)" 
  ```
### Notes:
* Init file stored in plans container on bjdterraform001 account in DevSub02_Storage_RG

## Terraform Apply
### Source:  
  ```
  $(System.DefaultWorkingDirectory)/_Kubernetes - Terraforms Build/drop
  ```
### Command: 
  ```
  terraform apply -auto-approve 
  ```
### Plan File:
* $(plan_file)

### Notes:
* Init file stored in plans container on bjdterraform001 account in DevSub02_Storage_RG

- Azure Blob Copy
Source: $(System.DefaultWorkingDirectory)/_Kubernetes - Terraforms Build/drop/$(plan_file)
Destination: plans container in bjdterraform001 account in DevSub02_Storage_RG

# Variables
* access_key - For blob storage account
* client_secret - client_id secret. Stored in KeyVault but access via Azure DevOps Released Pipeline
* plan_file - name of the terraform plan file
* ResourceGroupName - Resource Group in Azure to deploy to
