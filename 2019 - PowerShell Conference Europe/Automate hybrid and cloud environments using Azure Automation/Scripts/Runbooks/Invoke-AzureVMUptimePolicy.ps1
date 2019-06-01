Param(
    [string]$AzureSubscriptionName = 'All',    
    [string]$VMUptimePolicyTagValue = 'BusinessHours',
    [string]$VMAction = 'Start'    
)

<#

    NAME: Invoke-AzureVMUptimePolicy.ps1

    AUTHOR: Jan Egil Ring 
    EMAIL: jan.egil.ring(at)outlook.com

    COMMENT: Script to start and stop Azure virtual machines based on Azure resource tags

    Prerequisites:
    -A service account/principal that have permissions to the Azure subscriptions to process
    -An Azure Automation Account
    -Azure Resource Manager PowerShell module
 
    You have a royalty-free right to use, modify, reproduce, and 
    distribute this script file in any way you find useful, provided that 
    you agree that the creator, owner above has no warranty, obligations, 
    or liability for such use. 

    VERSION HISTORY: 
    1.0 05.10.2017 - Initial release 
    -Additional version history is available in Git

#>

Write-Output -InputObject "Runbook started $(Get-Date) on Azure Automation Runbook Worker $($env:computername)"
Write-Output "VM Action: $VMAction"

try {

    Import-Module -Name AzureRM.Compute -ErrorAction Stop
    
} catch {

    throw 'Prerequisites not installed - AzureRM.Compute  PowerShell module not installed'

}

$Credential = Get-AutomationPSCredential -Name SVCAzureAutomation

Write-Output "Trying to authenticate to Azure using credential $($Credential.UserName) ..."

try {
    
    $null = Add-AzureRmAccount -Credential $Credential -ErrorAction Stop -WarningAction SilentlyContinue
    
    $AzureRmContext = Get-AzureRmContext
    $AzureTenant = Get-AzureRmTenant
    
    Write-Output "Authenticated to Azure Resource Manager with user $($AzureRmContext.Account)"
            
}
                    
catch {
            
    throw  "Azure Resource Manager authentication failed: $($_.Exception.Message)"
                        
}

if ($AzureSubscriptionName -eq 'All') {

    Write-Output -InputObject "No subscription name specified, processing all available subscriptions..."

    $AzureSubscriptions = Get-AzureRmSubscription -WarningAction SilentlyContinue

} else {

    $AzureSubscriptions = Get-AzureRmSubscription -SubscriptionName $AzureSubscription -WarningAction SilentlyContinue

}

Write-Output -InputObject "Processing subscriptions:"
$AzureSubscriptions | Select-Object -Property Name, Id, TenantId | Sort-Object Name 


foreach ($AzureSubscription in $AzureSubscriptions) {


    Write-Output -InputObject "Processing virtual machines in subscription $($AzureSubscription.Name)..."

    $null = Set-AzureRmContext -SubscriptionId $AzureSubscription.Id

    #region Virtual Machines 

    $AzureRMVMs = Get-AzureRmVM -ErrorAction Ignore | Where-Object {$PSItem.Tags.UptimePolicy -eq $VMUptimePolicyTagValue}
    
    if ($AzureRMVMs) {
    
        Write-Output "Found the following Azure RM VMs with tag 'UptimePolicy' set to $VMUptimePolicyTagValue"
        $AzureRMVMs | Select-Object Name

        $Jobs = @()

            foreach ($ARMVM in $AzureRMVMs)  {

                $VMStatus = Get-AzureRmVM -ResourceGroupName $ARMVM.ResourceGroupName -Name $ARMVM.Name -Status | Select-Object Name, @{n = 'PowerState'; e = {($PSItem.Statuses | Where-Object Code -Like "*PowerState*").DisplayStatus}}
    
                switch ($VMAction) {
    
                    'Start' {                        

                        if ($VMStatus.PowerState -ne 'VM running') {

                            Write-Output "VM $($ARMVM.Name) is not running - starting"

                            $Job = $ARMVM | Start-AzureRmVM -AsJob
                            $Job.Name = $ARMVM.Name

                            $Jobs += $Job

                        } else {

                            Write-Output "VM $($ARMVM.Name) is already running - no action triggered"

                        }

                    }
                    'Stop' {

                        if ($VMStatus.PowerState -eq 'VM running') {
                            
                            Write-Output "VM $($ARMVM.Name) is running - stopping"
                            
                            $Job = $ARMVM | Stop-AzureRmVM -Force -AsJob
                            $Job.Name = $ARMVM.Name

                            $Jobs += $Job
                            
                        } else {
                            
                            Write-Output "VM $($ARMVM.Name) is already stopped - no action triggered"
                            
                        }

                    }
                    'Default' {Write-Output "VM Action $($VMAction) not defined in runbook, no action taken"}

                }

            }

            Write-Output "Sleeping for 5 minutes waiting for the following jobs to complete:"

            $Jobs | Select-Object Id,Name,State,PSBeginTime,PSEndTime

            Start-Sleep 300

            Write-Output "Job status after sleep:"

            $Jobs | Select-Object Id,Name,State,PSBeginTime,PSEndTime
    
    } else {
    
        Write-Output "No Azure RM VMs with tag 'UptimePolicy' set to $VMUptimePolicyTagValue found"
    
    }

    #endregion


}

Write-Output -InputObject "Runbook finished $(Get-Date)"