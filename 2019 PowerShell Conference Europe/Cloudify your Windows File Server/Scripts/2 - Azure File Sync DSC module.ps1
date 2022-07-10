Find-Module -Name xDSCResourceDesigner | Install-Module -Force

New-Item -Path "$env:ProgramFiles\WindowsPowerShell\Modules" -Name AzureFileSyncAgentDsc -ItemType Directory

New-ModuleManifest -Path "$env:ProgramFiles\WindowsPowerShell\Modules\AzureFileSyncAgentDsc\AzureFileSyncAgentDsc.psd1" -Guid (([guid]::NewGuid()).Guid) -Author 'Jan Egil Ring' -CompanyName PSCommunity -ModuleVersion 1.0 -Description 'DSC Resource Module for installing and configuring Azure File Sync agent' -PowerShellVersion 4.0 -FunctionsToExport '*.TargetResource'

# Define DSC resource properties

$AzureFileSyncInstanceName = New-xDscResourceProperty -Type String -Name AzureFileSyncInstanceName -Attribute Key

$Ensure = New-xDscResourceProperty -Name Ensure -Type String -Attribute Write -ValidateSet "Present", "Absent"

$AzureFileSyncSubscriptionId  = New-xDscResourceProperty -Name AzureSubscriptionId -Type String -Attribute Required
$AzureFileSyncResourceGroup  = New-xDscResourceProperty -Name AzureFileSyncResourceGroup -Type String -Attribute Required
$AzureCredential = New-xDscResourceProperty -Name AzureCredential -Type PSCredential -Attribute Required

# Create the DSC resource

New-xDscResource -Name AzureFileSyncAgent -Property $Ensure,$AzureFileSyncSubscriptionId,$AzureFileSyncResourceGroup,$AzureFileSyncInstanceName,$AzureCredential -Path "$env:ProgramFiles\WindowsPowerShell\Modules\AzureFileSyncAgentDsc" -ClassVersion 1.0 -FriendlyName AzureFileSyncAgent –Force

git clone git@github.com:janegilring/AzureFileSyncDsc.git (Resolve-Path ~\Git\AzureFileSyncDsc)

code (Resolve-Path ~\Git\AzureFileSyncDsc)