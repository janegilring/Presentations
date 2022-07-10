Connect-AzAccount
#Connect-AzureAD

# Resource Group name for the Automation Account
$rgName = "psconfeu2019-rg"
# Name of the Automation Account
$automationAccountName ="psconfeu2019"
# Name of the runbook
$rbName = "Invoke-RobocopyBackup"
#$userId = (Get-AzureADUser -ObjectId 'demo.user@janegilring.onmicrosoft.com').ObjectId
$userId = '51dcf38a-b1ef-414b-b85c-7bdb0a2069'

# Gets the Automation Account resource
$aa = Get-AzResource -ResourceGroupName $rgName -ResourceType "Microsoft.Automation/automationAccounts" -ResourceName $automationAccountName

# Get the runbook resource
$rb = Get-AzResource -ResourceGroupName $rgName -ResourceType "Microsoft.Automation/automationAccounts/runbooks"  | Where-Object Name -eq "$automationAccountName/$rbName"

# The Automation Job Operator role only needs to be run once per user
New-AzRoleAssignment -ObjectId $userId -RoleDefinitionName "Automation Job Operator" -Scope $aa.ResourceId

# Adds the user to the Automation Runbook Operator role to the runbook scope
New-AzRoleAssignment -ObjectId $userId -RoleDefinitionName "Automation Runbook Operator" -Scope $rb.ResourceId