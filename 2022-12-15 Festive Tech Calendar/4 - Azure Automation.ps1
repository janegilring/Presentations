Connect-AzAccount -UseDeviceAuthentication -Subscription 87b8def0-f5cf-402e-a8db-10e0ee958565

Get-AzContext

# Gotcha for PowerShell 7.1 and the latest Microsoft.Graph module:
# Could not load file or assembly 'Newtonsoft.Json, Version=13.0.0.0

# Oct 2022: Azure Automation now supports runbooks in PowerShell 7.2: https://azure.microsoft.com/en-us/updates/azure-automation-powershell7-python3/
# These new runtimes are currently supported only for Cloud jobs in five regions - West Central US, East US, South Africa North, North Europe, Australia Southeast
Start-Process https://azure.microsoft.com/en-us/updates/azure-automation-powershell7-python3/

New-AzResourceGroup -Name festive-tech-calendar-2022-rg -Location northeurope

$PSDefaultParameterValues.Add('*-AzAutomation*:AutomationAccountName','festive-tech-calendar-2022')
$PSDefaultParameterValues.Add('*-AzAutomation*:ResourceGroupName','festive-tech-calendar-2022-rg')
$PSDefaultParameterValues.Add('*-AzAutomation*:Location','northeurope')

New-AzAutomationAccount -Name festive-tech-calendar-2022 -AssignSystemIdentity

New-AzAutomationRunbook -Name Add-AzureADGroupMember -Type PowerShell -Description "Add users to sales-group"

Import-AzAutomationRunbook -Name Add-AzureADGroupMember -Path "/Users/janegilring/demo/Microsoft Graph/samples/runbooks/Add-AzureADGroupMember.ps1" -Type PowerShell
Publish-AzAutomationRunbook -Name Add-AzureADGroupMember

# Gotcha - not possible to add Graph permissions to the runbook account`s Managed Identity in the portal
Start-Process https://techcommunity.microsoft.com/t5/integrations-on-azure-blog/grant-graph-api-permission-to-managed-identity-object/ba-p/2792127

$DestinationTenantId = (Get-AzContext).Tenant.Id
Connect-MgGraph -TenantId $DestinationTenantId -UseDeviceAuthentication

$MsiName = "festive-tech-calendar-2022" # Name of system-assigned or user-assigned managed service identity. (System-assigned use same name as resource).

$oPermissions = @(
  "Group.ReadWrite.All"
  "GroupMember.ReadWrite.All"
  "User.ReadWrite.All"
)

$GraphAppId = "00000003-0000-0000-c000-000000000000" # Don't change this.

$oMsi = Get-AzADServicePrincipal -Filter "displayName eq '$MsiName'"
$oGraphSpn = Get-AzADServicePrincipal -Filter "appId eq '$GraphAppId'"

$oAppRole = $oGraphSpn.AppRole | Where-Object {($_.Value -in $oPermissions) -and ($_.AllowedMemberType -contains "Application")}

foreach($AppRole in $oAppRole)
{
  $oAppRoleAssignment = @{
    "PrincipalId" = $oMSI.Id
    "ResourceId" = $oGraphSpn.Id
    "AppRoleId" = $AppRole.Id
  }

  New-MgServicePrincipalAppRoleAssignment `
    -ServicePrincipalId $oAppRoleAssignment.PrincipalId `
    -BodyParameter $oAppRoleAssignment `
    -Verbose
}

#region Example runbook

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

#endregion