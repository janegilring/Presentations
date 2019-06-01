param (
    [Parameter(Mandatory = $true)]
    [string]
    $SourceUNCPath,
    [Parameter(Mandatory = $true)]
    [string]
    $TargetUNCPath
    )

<#

 NAME: Invoke-RobocopyBackup.ps1

 AUTHOR: Jan Egil Ring 
 EMAIL: jan.egil.ring(at)outlook.com

 COMMENT: Runbook to invoke scheduled backups of UNC paths
          

 VERSION HISTORY: 
 1.0 10.08.2018 - Initial release 

 #>

Write-Output -InputObject "Runbook Invoke-RobocopyBackup started $(Get-Date) on Azure Automation Runbook Worker $($env:computername)"


#region Variables

Write-Output -InputObject 'Getting variables from Azure Automation assets...'

$Credential = Get-AutomationPSCredential -name 'cred-domaincredential'

#endregion

try {

    Write-Output "Map source UNC Path $SourceUNCPath with drive letter X"
    New-PSDrive -Name X -PSProvider FileSystem -Persist -Credential $Credential -Root $SourceUNCPath -ErrorAction Stop

    Write-Output "Map target UNC Path $TargetUNCPath with drive letter Y"
    New-PSDrive -Name Y -PSProvider FileSystem -Persist -Credential $Credential -Root $TargetUNCPath -ErrorAction Stop

}

catch {

    Write-Error "Mapping drive letters for robocopy job failed: $($_.Exception.Message)"

    break

}

$TodayDateString = Get-Date -Format yyyy-MM-dd

$TargetUNCPath = Join-Path -Path $TargetUNCPath -ChildPath $TodayDateString

Write-Output 'Start robocopy.exe'
robocopy.exe $SourceUNCPath $TargetUNCPath /MIR /W:0 /R:1 /ZB

Write-Output 'Remove network connections X and Y'
Get-PSDrive -Name X | Remove-PSDrive
Get-PSDrive -Name Y | Remove-PSDrive

Write-Output -InputObject "Runbook finished $(Get-Date)"