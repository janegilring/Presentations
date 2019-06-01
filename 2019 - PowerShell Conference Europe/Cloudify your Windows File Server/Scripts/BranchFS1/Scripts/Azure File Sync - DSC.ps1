Install-Module -Name Az -Force

Connect-AzAccount
Set-AzContext -SubscriptionId xxxxxxxx

Import-Module Az.Automation

$PSDefaultParameterValues = @{
  "*AzAutomation*:ResourceGroupName" = 'West-Europe-Management'
  "*AzAutomation*:AutomationAccountName" = 'Automation-West-Europe'
}

# HybridFileServers - import configuration to Azure Automation
$SourcePath = '.\AzureFileSyncAgent\HybridFileServer.ps1'
Import-AzAutomationDscConfiguration -SourcePath $SourcePath -Force -Published -Tags @{Source='Git'}

# HybridFileServers - compile configuration in Azure Automation
$ConfigurationData = Import-PowerShellDataFile -Path '.\AzureFileSyncAgent\HybridFileServer_Configuration_Data.psd1'
$CompilationJob = Start-AzAutomationDscCompilationJob -ConfigurationName HybridFileServer -ConfigurationData $ConfigurationData


#region DSC LCM

$LCMComputerName = 'BranchFS2'
$NodeConfigurationName = 'HybridFileServer.BranchFS'
$LCMComputerName = @('FS1','FS2')
$NodeConfigurationName = 'HybridFileServer.ClusterFS'
$DSCMOFDirectory = 'C:\BootStrap\AzureAutomationDscMetaConfiguration'

# Create the metaconfigurations
$Params = @{
  RegistrationUrl = 'https://we-agentservice-prod-1.azure-automation.net/accounts/xxxxxx';
  RegistrationKey = 'xxxxxx';
  ComputerName = $LCMComputerName;
  NodeConfigurationName = $NodeConfigurationName;
  RefreshFrequencyMins = 720;
  ConfigurationModeFrequencyMins = 360;
  RebootNodeIfNeeded = $False;
  AllowModuleOverwrite = $True;
  ConfigurationMode = 'ApplyAndAutoCorrect';
  ActionAfterReboot = 'ContinueConfiguration';
  ReportOnly = $False;  # Set to $True to have machines only report to AA DSC but not pull from it
  OutputPath = $DSCMOFDirectory
}

. 'C:\Scripts\AzureAutomationDscMetaConfiguration.ps1'

AzureAutomationDscMetaConfiguration @Params

mkdir C:\BootStrap

$LCMComputerName = 'BRANCHFS2'
$DSCMOFDirectory = 'C:\BootStrap\AzureAutomationDscMetaConfiguration'

Set-DscLocalConfigurationManager -Path $DSCMOFDirectory -ComputerName $LCMComputerName -Force

Update-DscConfiguration -Wait -Verbose -CimSession $LCMComputerName

Get-DscLocalConfigurationManager -CimSession $LCMComputerName

#endregion