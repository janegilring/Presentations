#region Azure Resource Manager
# https://docs.microsoft.com/en-us/azure/virtual-machines/windows/quick-create-powershell

# Windows PowerShell - deprecated
Start-Process -FilePath powershell.exe -ArgumentList -NoProfile

# PowerShell - the future, also runs on Linux and Mac
Start-Process -FilePath pwsh.exe -ArgumentList -NoProfile

# Windows Terminal - modern terminal experience
Start-Process -FilePath wt.exe

# Once per machine/user
Install-Module -Name Az -Scope CurrentUser

# Frequent updates (typically monthly), remember to update the module
Update-Module -Name Az

# Check installed version
Get-Module -Name Az -ListAvailable

# If you have never used any PowerShell modules on your computer, verify that the PowerShell execution policy is not set to Restricted
Get-ExecutionPolicy

# If so, changing it to RemoteSigned is recommended
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# Since PowerShell 3.0, autoloading of modules became available - regardless, explicit import with required version specified is a best practice
Import-Module -Name Az #-RequiredVersion 2.5.0

# Connecting to Azure
$AzureCreds = Get-Credential -UserName user@domain.onmicrosoft.com -Message "Specify Azure credentials"
Connect-AzAccount -Credential $AzureCreds

# In PowerShell 6/7, Device Authentication is required
Connect-AzAccount

Get-AzContext

Get-AzSubscription
Set-AzContext -Subscription 'workshop-subscription'
Set-AzContext -Subscription 'f84a0018-96a8-4ecb-8708-ee3e64fdf28d'
Get-AzSubscription | Out-GridView -PassThru -Title 'Select subscription to operate against' | Set-AzContext

Disconnect-AzAccount

Get-AzVM

New-AzVm -Location norwayeast

Disconnect-AzAccount

#endregion