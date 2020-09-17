<#
    Prerequisites

    To run and debug functions locally, you will need to:
    • Install PowerShell Core/7
    • Install the .NET Core SDK 2.1+
    • Install Azure Functions Core Tools version 2.4.299 or later (update as often as possible)
        -Per September 2020 3.0.2881 is the latest
        -Also available via NPM: https://www.npmjs.com/package/azure-functions-core-tools

    To publish and run in Azure:
    • Install Azure PowerShell OR install the Azure CLI version 2.x or later.
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

New-AzResourceGroup -Name npug-rg -Location norwayeast -Tag @{expireson = '2020-09-17'}

$AppPlan = @{
    Name = 'npug-asp'
    ResourceGroupName = 'npug-rg'
    Location = 'Norway East'
    Sku = 'EP1' #Elastic Premium
    WorkerType = 'Windows'
}

New-AzFunctionAppPlan @AppPlan

$StorageAccount = @{
    Name = 'npugfunction'
    ResourceGroupName = 'npug-rg'
    Location = 'Norway East'
    SkuName = 'Standard_LRS'
}

New-AzStorageAccount @StorageAccount

$ApplicationInsights = @{
    Name = 'npug'
    ResourceGroupName = 'npug-rg'
    Location = 'West Europe'
    Kind = 'other'
}

New-AzApplicationInsights @ApplicationInsights

$App = @{
    Name = 'psfunctiondemo'
    ResourceGroupName = 'npug-rg'
    #Location = 'Norway East' #Only used when creating Consumption plan
    RunTime = 'PowerShell'
    RunTimeVersion = '7.0'
    FunctionsVersion = '3'
    PlanName = 'npug-asp'
    StorageAccount = 'npugfunction'
    ApplicationInsightsName = 'npug'
    OSType = 'Windows'
}

New-AzFunctionApp @App

az login

az account set -s "380d994a-e9b5-4648-ab8b-815e2ef18a2b"

az account show

#func azure functionapp publish <name of function app that was created in Azure>
func azure functionapp publish psfunctiondemo --force

Invoke-RestMethod 'https://psfunctiondemo.azurewebsites.net/api/MyHttpTrigger?code=62lTPGbofCLRy0BxGE5wS/YGFkAaMiUPgK5eInAiumhXoLIN14RstA==&Name=Jan'
