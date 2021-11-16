Param(
    [string]$AzureSubscriptionName = 'All',
    [string]$VMUptimePolicyTagValue = 'BusinessHours',
    [string]$VMAction = 'Start'
)

<#

    NAME: Invoke-AzureVMUptimePolicy.ps1

    AUTHOR: Jan Egil Ring
    EMAIL: jan.egil.ring@crayon.com

    COMMENT: Script to start and stop Azure virtual machines based on Azure resource tags

    Prerequisites:
    -A service account/principal that have permissions to the Azure subscriptions to process
        -A Managed Identity is recommended
    -An Azure Automation Account
    -Azure PowerShell module (Az.Compute)

    You have a royalty-free right to use, modify, reproduce, and
    distribute this script file in any way you find useful, provided that
    you agree that the creator, owner above has no warranty, obligations,
    or liability for such use.

#>

Write-Output -InputObject "Runbook started $(Get-Date) on Azure Automation Runbook Worker $($env:computername)"
Write-Output "VM Action: $VMAction"

try {

    Import-Module -Name Az.Compute -ErrorAction Stop -RequiredVersion 3.5.0

} catch {

    throw 'Prerequisites not installed - Az PowerShell module not installed'

}

#$Credential = Get-AutomationPSCredential -Name cred-Azure

Write-Output "Trying to authenticate to Azure using credential $($Credential.UserName) ..."

try {

    #$null = Connect-AzAccount -Credential $Credential -ErrorAction Stop -WarningAction SilentlyContinue
    $null = Connect-AzAccount -Identity -ErrorAction Stop


    $AzContext = Get-AzContext

    Write-Output "Authenticated to Azure Resource Manager with user $($AzContext.Account)"

}

catch {

    throw  "Azure Resource Manager authentication failed: $($_.Exception.Message)"

}

if ($AzureSubscriptionName -eq 'All') {

    Write-Output -InputObject "No subscription name specified, processing all available subscriptions..."

    $AzureSubscriptions = Get-AzSubscription -WarningAction SilentlyContinue

} else {

    $AzureSubscriptions = Get-AzSubscription -SubscriptionName $AzureSubscription -WarningAction SilentlyContinue

}

Write-Output -InputObject "Processing subscriptions:"
$AzureSubscriptions | Select-Object -Property Name, Id, TenantId | Sort-Object Name

foreach ($AzureSubscription in $AzureSubscriptions) {

    Write-Output -InputObject "Processing virtual machines in subscription $($AzureSubscription.Name)..."

    $null = Set-AzContext -SubscriptionId $AzureSubscription.Id

    #region Virtual Machines

    $AzureRMVMs = Get-AzVM -ErrorAction Ignore | Where-Object { $PSItem.Tags.UptimePolicy -eq $VMUptimePolicyTagValue}

    if ($AzureRMVMs) {

        Write-Output "Found the following Azure VMs with tag 'UptimePolicy' set to $VMUptimePolicyTagValue"
        $AzureRMVMs | Select-Object Name

        $Jobs = @()

        Foreach ($ARMVM in $AzureRMVMs) {

            if ($ARMVM) {

                switch ($VMAction) {

                    'Start' {

                        Write-Output "Starting VM $($ARMVM.Name)"
                        $Job = $ARMVM | Start-AzVM -AsJob
                        $Job.Name = $ARMVM.Name

                        $Jobs += $Job

                    }
                    'Stop' {

                        Write-Output "Stopping VM $($ARMVM.Name)"
                        $Job = $ARMVM | Stop-AzVM -Force -AsJob
                        $Job.Name = $ARMVM.Name

                        $Jobs += $Job

                    }
                    'Default' { Write-Output "VM Action $VMAction not defined in runbook, no action taken" }

                }

            }

        }

            Write-Output "Waiting for the following jobs to complete:"

            $Jobs | Select-Object Id,Name,State,PSBeginTime,PSEndTime

            $Jobs | Wait-Job

            Write-Output "Job status after waiting:"

            $Jobs | Select-Object Id,Name,State,PSBeginTime,PSEndTime

    } else {

        Write-Output "No Azure VMs with tag 'UptimePolicy' set to $VMUptimePolicyTagValue found"

    }

    #endregion

}

Write-Output -InputObject "Runbook finished $(Get-Date)"