<#
    Prerequisites

    To run and debug functions locally, you will need to:
    • Install PowerShell 7.2
    • Install the .NET Core 3.1 runtime
    • Install the Azure Functions extension for Visual Studio Code
    • Install Azure Functions Core Tools version 4.x or later
        -Also available via NPM: https://www.npmjs.com/package/azure-functions-core-tools

    To publish and run in Azure:
    • Install Azure PowerShell or install the Azure CLI v.
    • You need an active Azure subscription.

#>


# An introduction to Azure Functions
Start-Process https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview

# Azure Functions developers guide
Start-Process https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference

# Azure Functions PowerShell developer guide
Start-Process https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference-powershell

cd c:\demos

mkdir PSFunctionDemo

cd PSFunctionDemo

code .

func init --worker-runtime powershell

func new -l powershell -t HttpTrigger -n MyHttpTrigger

dir -Recurse

<#
• .vscode - A folder that recommends VS Code extensions to the user
• MyHttpTrigger - The folder that contains the function
• .gitignore - A file used by Git to ignore certain local build/test artifacts from source control
• host.json - Contains global configuration options that affect all functions for a function app
• local.settings.json - Contains the configuration settings for your function app that can be published to “Application Settings” in your Azure function app environment
• profile.ps1 - A PowerShell script that will be executed on every cold start of your language worker
• function.json - Contains the configuration metadata for the Function and the definition of input and output bindings
• run.ps1 - This is the script that will be executed when a Function is triggered
• sample.dat - Contains the sample data that will be displayed in the Azure Portal for testing purposes
#>

# Note: Remove dependency on Az-module before start, and add " - from PowerShell $($PSVersionTable.PSVersion.ToString())"
func start

Invoke-RestMethod http://localhost:7071/api/MyHttpTrigger?Name=Jan

# Notice the PowerShell version is 6.2.x, but what if we want 7?

# Stop function (Ctrl + C), then add the following to local.settings.json: "FUNCTIONS_WORKER_RUNTIME_VERSION" : "~7",
func start

Invoke-RestMethod http://localhost:7071/api/MyHttpTrigger?Name=Jan

Connect-AzAccount

Set-AzContext -Subscription 380d994a-e9b5-4648-ab8b-815e2ef18a2b

Get-AzContext

Install-Module -Name Az.Functions

Get-Command -Module Az.Functions

$ResourceGroupName = 'festive-tech-calendar-2022-rg'
$Location = 'westeurope'

$AppPlan = @{
    Name = 'festive-tech-calendar-2022-asp'
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    Sku = 'EP1' #Elastic Premium
    WorkerType = 'Linux'
}

New-AzFunctionAppPlan @AppPlan

$StorageAccount = @{
    Name = 'festivetech2022function'
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    SkuName = 'Standard_LRS'
}

New-AzStorageAccount @StorageAccount

$ApplicationInsights = @{
    Name = 'festivetechcalendar2022'
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    Kind = 'other'
}

New-AzApplicationInsights @ApplicationInsights

$App = @{
    Name = 'festivetechcalendar2022'
    ResourceGroupName = $ResourceGroupName
    #Location = $Location #Only used when creating Consumption plan
    RunTime = 'PowerShell'
    RunTimeVersion = '7.2'
    FunctionsVersion = '4'
    IdentityType = 'SystemAssigned'
    PlanName = 'festive-tech-calendar-2022-asp'
    StorageAccount = 'festivetech2022function'
    ApplicationInsightsName = 'festivetechcalendar2022'
    OSType = 'Linux'
}

New-AzFunctionApp @App


$DestinationTenantId = (Get-AzContext).Tenant.Id
Connect-MgGraph -TenantId $DestinationTenantId -UseDeviceAuthentication

$MsiName = "festivetechcalendar2022" # Name of system-assigned or user-assigned managed service identity. (System-assigned use same name as resource).

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