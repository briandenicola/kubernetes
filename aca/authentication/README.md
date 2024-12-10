# Quicksteps
## Complete Environment
* Create an Azure App Registration following: https://learn.microsoft.com/en-us/azure/container-apps/authentication-entra
    * Create an Client and Secret and save in an variable named AZURE_APP_REGISTRATION_CLIENT_SECRET
* Create the environment
    ```bash
        az login --scope https://graph.microsoft.com/.default
        task up
    ```
* Create an Container App Environmental Secret name `microsoft-provider-authentication-secret` that containing the client secret created above
    ```bash
        task secret -- ${AZURE_APP_REGISTRATION_CLIENT_SECRET}}
    ```
* Configure the Container App Authentication
    ```bash
        task auth
    ```
# Validate 
```bash

```

# Clean up
```bash
    task down
```
