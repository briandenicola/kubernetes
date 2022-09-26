param (
    [Parameter(Mandatory=$true)]
    [Uri] $AksApiUri,

    [Parameter(Mandatory=$true)]
    [string] $TenantID,

    [Parameter(Mandatory=$true)]
    [string] $ClientID

)

$creds = Get-Credential -UserName $ClientID -Message "Please enter the Client Secret for $ClientID"
$uri = "https://login.microsoftonline.com/$TenantID/oauth2/token"

if( -not ($AksApiUri.IsAbsoluteUri) ) {
    $AksApiUri = "https://{0}" -f $AksApiUri
}
$namespaceUri =  "{0}api/v1/namespaces" -f $AksApiUri

Write-Host ("[{0}] - Authenticating {1} . . ." -f (Get-Date), $ClientID)
$auth = Invoke-RestMethod -Uri $uri  -Method Post -Body @{
    "grant_type" = "client_credentials"; 
    "resource" = "6dae42f8-4368-4678-94ff-3960e28e3630"; 
    "client_id" = $creds.UserName ; 
    "client_secret" = $creds.GetNetworkCredential().Password 
} 

$h = @{}; $h.Add('Authorization', ('{0} {1}' -f $auth.token_type, $auth.access_token))

Write-Host ("[{0}] - Getting all namespaces againist {1} . . ." -f (Get-Date), $AksApiUri.DnsSafeHost)
Invoke-RestMethod -Method get -SkipCertificateCheck -Headers $h -ContentType "application/json" -Uri $namespaceUri |
     Select-Object @{Name = 'Name'; Expression = {$_.items.metadata.name}} | 
     Select-Object -ExpandProperty Name