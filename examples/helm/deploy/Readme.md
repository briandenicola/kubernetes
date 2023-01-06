# Overview 
Documenting how to deploy a Helm Chart using Azure DevOps Release Pipeline. 

# Steps
##  Helm Tool Installer
* Just utilizing the Azure Helm Installer Task 

## Package and Deploy Helm charts
### Command: 
```
  helm upgrade --install --set build_version="1.0.$(Release.ReleaseId)",buildid=$(Build.BuildNumber) --wait fun-flee "$(System.DefaultWorkingDirectory)/_Go Build Pipeline/goexamplechart" 
```
## Notes
* Install if release not present 

## Variables