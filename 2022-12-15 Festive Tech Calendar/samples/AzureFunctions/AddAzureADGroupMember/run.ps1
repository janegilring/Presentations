using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$body = "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."

if ($name) {
    $body = "Hello, $name. This HTTP triggered function executed successfully."
}

# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity
$null = Connect-AzAccount -Identity

$accessToken = (Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com").Token #MS Graph audience -Scopes "User.Read.All","Group.ReadWrite.All"

Connect-MgGraph -AccessToken $accessToken

Get-MgUser -UserId User1@MngEnvMCAP163424.onmicrosoft.com |
Select-Object UserPrincipalName, DisplayName, Department, JobTitle, Mail, MobilePhone, OfficeLocation, PreferredLanguage, UsageLocation


$GroupId = (Get-MgGroup -Filter "displayName eq 'Demo Users'").Id

[array]$Users = Get-MgUser -Filter "department eq 'Sales'"

ForEach ($User in $Users) {

  New-MgGroupMember -GroupId $GroupId -DirectoryObjectId $User.Id

}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
