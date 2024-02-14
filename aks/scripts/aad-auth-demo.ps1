param (
    [Parameter(Mandatory=$true)]
    [Uri] $AksApiUri,

    [Parameter(Mandatory=$true)]
    [string] $TenantID,

    [Parameter(Mandatory=$true)]
    [string] $ClientID,

    [Parameter(Mandatory=$true)]
    [string] $ClientSecret

)

#$creds = Get-Credential -UserName $ClientID -Message "Please enter the Client Secret for $ClientID"
$creds = New-PSCredentials -UserName $ClientID -Password $ClientSecret
$uri = "https://login.microsoftonline.com/$TenantID/oauth2/token"

if( -not ($AksApiUri.IsAbsoluteUri) ) {
    $namespaceUri = New-Object System.UriBuilder -ArgumentList ([uri]::UriSchemeHttps), $AksApiUri, 443, "api/v1/namespaces"
} else {
    $namespaceUri = New-Object System.UriBuilder($AksApiUri)
    $namespaceUri.Path = "api/v1/namespaces"
}

Write-Host ("[{0}] - Authenticating {1} . . ." -f (Get-Date), $ClientID)
$auth = Invoke-RestMethod -Uri $uri  -Method Post -Body @{
    "grant_type" = "client_credentials"; 
    "resource" = "6dae42f8-4368-4678-94ff-3960e28e3630"; 
    "client_id" = $creds.UserName ; 
    "client_secret" = $creds.GetNetworkCredential().Password 
} 

$h = @{}; $h.Add('Authorization', ('{0} {1}' -f $auth.token_type, $auth.access_token))

Write-Host ("[{0}] - Access token: {1}..." -f (Get-Date), $auth.access_token)
Write-Host ("[{0}] - Getting all namespaces againist {1} . . ." -f (Get-Date), $AksApiUri.DnsSafeHost)
Invoke-RestMethod -Method get -SkipCertificateCheck -Headers $h -ContentType "application/json" -Uri $namespaceUri.ToString() |
     Select-Object @{Name = 'Name'; Expression = {$_.items.metadata.name}} | 
     Select-Object -ExpandProperty Name


if( -not ($AksApiUri.IsAbsoluteUri) ) {
    $namespaceUri = New-Object System.UriBuilder -ArgumentList ([uri]::UriSchemeHttps), $AksApiUri, 443, "api/v1/namespaces/kube-system/pods"
} else {
    $namespaceUri = New-Object System.UriBuilder($AksApiUri)
    $namespaceUri.Path = "api/v1/namespaces/kube-system/pods"
}

Write-Host ("[{0}] - Getting all pods in kube-system on {1} . . ." -f (Get-Date), $AksApiUri.DnsSafeHost)
Invoke-RestMethod -Method get -SkipCertificateCheck -Headers $h -ContentType "application/json" -Uri $namespaceUri.ToString() |
     Select-Object @{Name = 'Name'; Expression = {$_.items.metadata.name}} | 
     Select-Object -ExpandProperty Name