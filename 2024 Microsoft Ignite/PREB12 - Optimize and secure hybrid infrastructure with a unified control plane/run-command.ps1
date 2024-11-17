# Documentation
Start-Process https://learn.microsoft.com/en-us/azure/azure-arc/servers/run-command

# Azure CLI

az login
az extension add --name connectedmachine

$RGname = "tailwind-traders-rg"
$MachineName = "twt-app-01" # Windows
$MachineName = "twt-web-01" # Linux
$Location = (Get-AzResourceGroup -Name $RGName).Location

<#
RunCommand Create:
az connectedmachine run-command create -g <resource-group> --machine-name <machine-name> -n <runcommand-name> --script "Write-Host 'Hello World'" --location <centraluseuap/eastus2euap>
#>

az connectedmachine run-command create -g $RGname --machine-name $MachineName -n demo1 --script "Write-Host 'Hello World'" --location westeurope

az connectedmachine run-command create -g $RGname --machine-name $MachineName -n demo1 --script "Restart-Service spooler -PassThru" --location westeurope --no-wait

az connectedmachine run-command create -g $RGname --machine-name $MachineName -n demo1 --script "Write-Host 'Hello World'" --location westeurope

az connectedmachine run-command create --help

# --command-id                            : Specifies the commandId of predefined built-in script.
# --script-uri
#  --script-uri-managed-identity           : User-assigned managed identity that has access to scriptUri in case of Azure storage blob.


<#
RunCommand Get:
az connectedmachine run-command show -g <resource-group> --machine-name <machine-name> -n <runcommand-name>
#>

az connectedmachine run-command show -g $RGname --machine-name $MachineName -n demo1
az connectedmachine run-command show -g $RGname --machine-name $MachineName -n demo1 | ConvertFrom-Json | Select-Object -ExpandProperty InstanceView

az connectedmachine run-command show -g $RGname --machine-name $MachineName -n demo2

az connectedmachine run-command show -g $RGname --machine-name $MachineName -n demo1

<#
RunCommand List:
az connectedmachine run-command list -g <resource-group> --machine-name <machine-name>
#>

az connectedmachine run-command list -g $RGname --machine-name $MachineName

az connectedmachine run-command list -g $RGname --machine-name $MachineName

<#
RunCommand Delete:
az connectedmachine run-command delete -g <resource-group> --machine-name <machine-name> -n <runcommand-name>
#>

az connectedmachine run-command delete -g $RGname --machine-name $MachineName -n demo1



# Azure PowerShell

Connect-AzAccount

Install-Module Az.ConnectedMachine -RequiredVersion 0.9.0

Import-Module Az.ConnectedMachine -PassThru

New-AzConnectedMachineRunCommand -ResourceGroupName "<Resource Group Name>" -Location "<Location>" -SourceScript "ifconfig" -RunCommandName "<Identifying Name of command>" -MachineName "<Machine Name>"

$RGname = "tailwindtraders-arc-servers"
$MachineName = "twt-app-01" # Windows
#$MachineName = "twt-web-01" # Linux
$Location = (Get-AzResourceGroup -Name $RGName).Location

New-AzConnectedMachineRunCommand -ResourceGroupName $RGname -Location $Location -SourceScript "Get-Process | Sort-Object CPU -desc | Select-Object -First 5" -RunCommandName "ProcInfo" -MachineName $MachineName #-AsyncExecution

Get-AzConnectedMachineRunCommand -ResourceGroupName $RGname -RunCommandName "ProcInfo" -MachineName $MachineName

Get-AzConnectedMachineRunCommand -ResourceGroupName $RGname -RunCommandName "ProcInfo" -MachineName $MachineName | Select-Object -ExpandProperty InstanceViewOutput

$MachineName = "twt-web-01" # Linux
New-AzConnectedMachineRunCommand -ResourceGroupName $RGname -Location $Location -SourceScript "ps" -RunCommandName "ProcInfo" -MachineName $MachineName #-AsyncExecution

Get-AzConnectedMachineRunCommand -ResourceGroupName $RGname -RunCommandName "ProcInfo" -MachineName $MachineName | Select-Object -ExpandProperty InstanceViewOutput


<#
    Run from source script in blob storage and redirect output to blob
    New-AzConnectedMachineRunCommand -ResourceGroupName -MachineName -RunCommandName -SourceScriptUri “< SAS URI of a storage blob with read access or public URI>” -OutputBlobUri “< SAS URI of a storage append blob with read, add, create, write access>” -ErrorBlobUri “< SAS URI of a storage append blob with read, add, create, write access>”
#>


$MachineName = "twt-web-01" # Linux
Remove-AzConnectedMachineRunCommand -ResourceGroupName $RGname -RunCommandName "ProcessInfo" -MachineName $MachineName

$MachineName = "twt-app-01" # Windows
Remove-AzConnectedMachineRunCommand -ResourceGroupName $RGname -RunCommandName "ProcessInfo" -MachineName $MachineName