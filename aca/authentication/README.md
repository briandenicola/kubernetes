# Quicksteps
## Complete Environment
* Create an Azure App Registration following: https://learn.microsoft.com/en-us/azure/container-apps/authentication-entra
    * Create an Client and Secret and save in a bash variable named AZURE_APP_REGISTRATION_CLIENT_SECRET
* Create the environment
    ```bash
        az login --scope https://graph.microsoft.com/.default
        task up
    ```
* Create an Container App Environmental Secret name `microsoft-provider-authentication-secret` that containing the client secret created above
    ```bash
        task secret -- ${AZURE_APP_REGISTRATION_CLIENT_SECRET}
    ```
* Configure the Container App Authentication
    ```bash
        task auth
    ```
# Validate 
* Connect to the Virtual Machine via Azure Bastion
```bash
    # Install jq
    sudo apt update
    sudo apt install -y jq
```
```bash
    #Test an authorized call to the API. This should fail with 401 HTTP Unauthorized
    curl -vvv  https://${HTTP_BIN_APPPLICATION_URL}
```
```bash
    # Get the token from the Managed Identity
    token= `curl -s -H "Metadata: true" "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&&client_id=${CLIENT_ID_OF_VM_MI}&resource=api://${APP_ID_OF_SPN_CREATED_IN_FIRST_STEP}" | jq -r .access_token`
    
    # Call the API with the token   
    curl -vvv -H "Authorization: bearer ${token}" https://${HTTP_BIN_APPPLICATION_URL}
```

## 401 Unauthorized Example 
```bash
curl -vvvv  https://httpbin.icygrass-d6a09ab0.canadaeast.azurecontainerapps.io
...
GET / HTTP/2
> Host: httpbin.icygrass-d6a09ab0.canadaeast.azurecontainerapps.io
> user-agent: curl/7.81.0
> accept: */*
> 
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* old SSL session ID is stale, removing
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
< HTTP/2 401 
< date: Tue, 10 Dec 2024 14:56:44 GMT
< www-authenticate: Bearer realm="httpbin.icygrass-d6a09ab0.canadaeast.azurecontainerapps.io" authorization_uri="https://login.microsoftonline.com/16b3c013-d300-4
68d-ac64-7eda0820b6d3/oauth2/v2.0/authorize" resource_id="963c6f8d-b848-4e44-82ea-2c6a454e863b"
< x-ms-middleware-request-id: dc94e105-d441-4fff-9719-cd8130413387
< strict-transport-security: max-age=31536000; includeSubDomains
< 
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* Connection #0 to host httpbin.icygrass-d6a09ab0.canadaeast.azurecontainerapps.io left intact
```

## Authorized Example 
```bash
token=`curl -s -H "Metadata: true" "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&client_id=1362aaa3-1ee6-412c-81ea-b46c3d8828be&resource=api://963c6f8d-b848-4e44-82ea-2c6a454e863b" | jq -r .access_token`
curl -vvv -H "Authorization: bearer ${token}" https://httpbin.icygrass-d6a09ab0.canadaeast.azurecontainerapps.io
} [5 bytes data]
> GET / HTTP/2
> Host: httpbin.icygrass-d6a09ab0.canadaeast.azurecontainerapps.io
> user-agent: curl/7.81.0
> accept: */*
> authorization: bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Inp4ZW...REDACTED....
...
< HTTP/2 200 
< content-length: 12144
< content-type: text/html; charset=utf-8
< date: Tue, 10 Dec 2024 15:02:53 GMT
< server: gunicorn
< access-control-allow-credentials: true
< access-control-allow-origin: *
< x-ms-middleware-request-id: 17727406-0a03-4ea8-842e-45e85bb2efff
< strict-transport-security: max-age=31536000; includeSubDomains
< 
{ [12144 bytes data]
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv='content-type' value='text/html;charset=utf8'>
  <meta name='generator' value='Ronn/v0.7.3 (http://github.com/rtomayko/ronn/tree/0.7.3)'>
  <title>httpbin(1): HTTP Client Testing Service</title>
...
<p>A <a href="http://kennethreitz.com/">Kenneth Reitz</a> project.</p>
<p>BTC: <a href="https://www.kennethreitz.org/bitcoin"><code>1Me2iXTJ91FYZhrGvaGaRDCBtnZ4KdxCug</code></a></p>

<h2 id="SEE-ALSO">SEE ALSO</h2>

<p><a href="https://www.hurl.it">Hurl.it</a> - Make HTTP requests.</p>
<p><a href="http://requestb.in">RequestBin</a> - Inspect HTTP requests.</p>
<p><a href="http://python-requests.org" data-bare-link="true">http://python-requests.org</a></p>

</div>
</body>
</html>
```

# Clean up
```bash
    task down
```