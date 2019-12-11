This is to demo ACR Build Task with Azure DevOps

## Build Base
* az acr task create -n base-w2k19 -r bjd145 -t windows/bjdbasewindows2019:ltsc2019 
    -f ACR/Dockerfile.base
    --platform windows 
    --context https://github.com/bjd145/Kubernetes.git 
    --commit-trigger-enabled false 
    --pull-request-trigger-enabled false
* Or run ./create_acr_task.ps1 

## Create an Azure Build Pipeline 
* Use the Build-Pipeline\build-pipeline.yaml 
    * Note: Build ID 
* Update azure.parameters.prd.json to include the Build ID and Project Name

## Push Notification WebHook
* az group create -n Test -l southcentralus
* az group deployment create -g Test --template-file .\azuredeploy.json --parameters .\azure.parameters.prd.json
* az acr webhook create --registry bjd145 --name PushNotification --actions push --uri {Taken from ARM Ouput}

