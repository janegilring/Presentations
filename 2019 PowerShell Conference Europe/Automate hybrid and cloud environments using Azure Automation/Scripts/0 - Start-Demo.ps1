break #Safety net against running the script as a whole, it is meant to be run line by line

# Change to Git-repo
cd '~\Presentations\PowerShell Conference\PSConfEU2019\Scripts - Azure Automation\'

function Open-Website {
param ($URL)

    Start-Process -FilePath chrome.exe -ArgumentList $URL

}

#region Getting started

# Documentation
Open-Website -URL 'https://docs.microsoft.com/en-us/azure/automation/'

# Creating an Automation account - option 1 (portal)
Open-Website -URL 'https://portal.azure.com/#blade/HubsExtension/BrowseResourceBlade/resourceType/Microsoft.Automation%2FAutomationAccounts'

# Creating an Automation account - option 1 (PowerShell)
Connect-AzAccount

New-AzResourceGroup -Name psconfeu2019-rg -Location westeurope
New-AzAutomationAccount -Name psconfeu2019 -ResourceGroupName psconfeu2019-rg -Location westeurope

# Creating an Automation account - option 3 (Terraform)
psedit '.\Terraform\automation_account.tf'

Open-Website -URL 'https://www.terraform.io/docs/providers/azurerm/r/automation_account.html'

<# Basics

    - Shared resources
    - Update Management
    - Inventory
    - Change Tracking
    - State Configuration (DSC)
        - Azure File Sync demo
    - Process Automation
        - Runbooks
        - Watcher tasks
        - Hybrid workers

#>

#endregion

#region Real world tips and tricks

# Publish Azure Automation artifacts (runbooks, modules, DSC configurations) using a release pipeline
Open-Website -URL 'https://dev.azure.com/janegilring'

# Configuring role-based access control (RBAC) for runbooks in Azure Automation by Jan Egil Ring
Open-Website -URL 'https://www.powershellmagazine.com/2018/08/27/configuring-role-based-access-control-rbac-for-runbooks-in-azure-automation/'

psedit '.\1 - Configuring role-based access control (RBAC) for runbooks in Azure Automation.ps1'

# Calling runbooks via webhooks. Example using Microsoft Teams.
Open-Website -URL 'https://docs.microsoft.com/en-us/azure/automation/automation-webhooks'
Open-Website -URL 'https://poshbot.readthedocs.io/en/latest/guides/backends/setup-teams-backend/'
Open-Website -URL 'https://docs.microsoft.com/en-us/microsoftteams/platform/concepts/outgoingwebhook'

psedit .\Runbooks\Test-MicrosoftTeams.ps1

# Pre/post actions for update management
Open-Website -URL 'https://docs.microsoft.com/en-us/azure/automation/pre-post-scripts'

# Use an alert to trigger an Azure Automation runbook
Open-Website -URL 'https://docs.microsoft.com/en-us/azure/automation/automation-create-alert-triggered-runbook'

# Hybrid workers - updating modules
Open-Website -URL 'https://github.com/mortenlerudjordet/runbooks/tree/master/Utility/ARM'

# Tip: Converting a PowerShell Project to use Azure DevOps Pipelines by Daniel Scott-Raynsford
Open-Website -URL 'https://www.powershellmagazine.com/2018/09/20/converting-a-powershell-project-to-use-azure-devops-pipelines/'

#endregion