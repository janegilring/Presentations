Import-Module Az.Automation

$PSDefaultParameterValues = @{
  "*AzAutomation*:ResourceGroupName" = 'jer-management-rg'
  "*AzAutomation*:AutomationAccountName" = 'Automation-West-Europe'
}

# HybridFileServers
$SourcePath = '.\DSC\HybridFileServer.ps1'
Import-AzAutomationDscConfiguration -SourcePath $SourcePath -Force -Published -Tags @{Source='Azure DevOps'}

psedit $SourcePath

# HybridFileServers
$ConfigurationDataPath = '.\DSC\HybridFileServers.psd1'
$ConfigurationData = Import-PowerShellDataFile -Path $ConfigurationDataPath
Start-AzAutomationDscCompilationJob -ConfigurationName HybridFileServer -ConfigurationData $ConfigurationData

psedit $ConfigurationDataPath