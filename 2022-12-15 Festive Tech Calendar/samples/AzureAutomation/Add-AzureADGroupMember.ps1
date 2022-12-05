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