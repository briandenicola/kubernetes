# Overview

This repository is a demostration on how to deploy a private Azure ML Workspace with an interference compute cluster attached. Outbound connectivity on the Azure ML Compute subnet is locked down to just what is required for Azure ML to function


# Quicksteps
## Complete Environment
```bash
    az login --scope https://graph.microsoft.com/.default
    task up
```

## Clean up
```bash
    task down
```

## Notes
* The AzureML Workspace will have a private endpoint but will be open to the public internet by default

# Validate 
TBD

# Backlog
- [ ] Add jumpbox VM to access Azure ML over Private Link instead of Public IP configuration could be created for a jumpbox Windows machine to access 

