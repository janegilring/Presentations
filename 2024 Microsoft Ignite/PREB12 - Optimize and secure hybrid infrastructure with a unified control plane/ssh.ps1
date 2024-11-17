# SSH access to Azure Arc-enabled servers
Start-Process "https://learn.microsoft.com/azure/azure-arc/servers/ssh-arc-overview"

#region Prerequisites

    # Azure CLI extension
    az extension add --name ssh

    # Verify the installation
    az extension list --output table

    # Azure PowerShell modules
    Install-PSResource -Name Az.Ssh -TrustRepository
    Install-PSResource -Name Az.Ssh.ArcProxy -TrustRepository

    # Verify the installation
    Get-Module -ListAvailable -Name Az.Ssh*

    # On the Arc-enabled Windows Servers, install the OpenSSH Server feature
    # - On Windows Server 2025, this feature is installed by default but needs to be configured

    # Verify the status of the sshd service
    Get-Service sshd

    # If not present and running:

    # Install the OpenSSH Server
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

    # Start the sshd service
    Start-Service sshd

    # Configure the service to start automatically
    Set-Service -Name sshd -StartupType 'Automatic'

    # Confirm the Windows Firewall is configured to allow SSH. The rule should be created automatically by setup. Run the following to verify:
    if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
        Write-Output "Firewall Rule "OpenSSH-Server-In-TCP" does not exist, creating it..."
        New-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -DisplayName "OpenSSH Server (sshd)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
    } else {
        Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
    }

#endregion

# Authenticate

# Azure CLI
az login

# Show current context
az account show --output table

# Azure PowerShell
Connect-AzAccount

Get-AzContext

$resourceGroup = "tailwindtraders-ignite-preday"

#region Windows

$serverName = "twtdemo-app-02"
$localUser = "Administrator"

az ssh arc --resource-group $resourceGroup --name $serverName --local-user $localUser

Enter-AzVM -ResourceGroupName $resourceGroup -Name $serverName -LocalUser $localUser

# Remote Desktop Protocol (RDP)
$serverName = "twtdemo-app-02"
$localUser = "Administrator"

az ssh arc --resource-group $resourceGroup --name $serverName --local-user $localUser --rdp

Enter-AzVM -ResourceGroupName $resourceGroup -Name $serverName -LocalUser $localUser -Rdp

#endregion

#region Linux

$serverName = "twtdemo-web-02"
$localUser = "jumpstart"
$resourceGroup = "tailwindtraders-ignite-preday"
$azureLocation = "eastus"

# Local user
az ssh arc --resource-group $resourceGroup --name $serverName --local-user $localUser

Enter-AzVM -ResourceGroupName $resourceGroup -Name $serverName -LocalUser $localUser

# Entra ID authentication
az connectedmachine extension create --machine-name $serverName --resource-group $resourceGroup --publisher Microsoft.Azure.ActiveDirectory --name AADSSHLogin --type AADSSHLoginForLinux --location $azureLocation

$User = Get-AzAdUser -Mail (Get-AzContext).Account.Id
$Scope = "/subscriptions/$((Get-AzContext).Subscription.Id)/resourceGroups/$resourceGroup/providers/Microsoft.HybridCompute/machines/$serverName"

# Azure CLI
az role assignment create --role "Virtual Machine Administrator Login" --assignee $User.Id --scope $Scope

# Azure PowerShell
New-AzRoleAssignment -ObjectId $User.Id -RoleDefinitionName "Virtual Machine Administrator Login" -Scope $Scope

az ssh arc --resource-group $resourceGroup --name $serverName

Enter-AzVM -ResourceGroupName $resourceGroup -Name $serverName

# PowerShell Remoting via SSH
# https://learn.microsoft.com/azure/azure-arc/servers/ssh-arc-powershell-remoting

$Machines = Get-AzConnectedMachine -ResourceGroupName $resourceGroup | Where-Object Status -eq "Connected"
$sessions = @()

foreach ($Machine in $Machines) {

    $serverName = $Machine.Name
    $resourceGroup = $Machine.ResourceGroupName
    $localUser = "administrator"
    $configFile = "C:\temp\$serverName"

    Remove-Item $configFile -ErrorAction SilentlyContinue
    Export-AzSshConfig -ResourceGroupName $resourceGroup -Name $serverName -LocalUser $localUser -ResourceType Microsoft.HybridCompute/machines -ConfigFilePath $configFile

    # Use a regex pattern to find the ProxyCommand line and extract its value
    $proxyCommandPattern = 'ProxyCommand\s+"([^"]+)"\s+-r\s+"([^"]+)"'
    $match = Select-String -Path $configFile -Pattern $proxyCommandPattern

    $proxyCommandValue1 = [regex]::Match($match.Line, $proxyCommandPattern).Groups[1].Value
    $proxyCommandValue2 = [regex]::Match($match.Line, $proxyCommandPattern).Groups[2].Value
    $fullProxyCommandValue = "`"$proxyCommandValue1 -r $proxyCommandValue2`""

    $options = @{ ProxyCommand = $fullProxyCommandValue }

    $sessions += New-PSSession -HostName $serverName -UserName $localUser -Options $options -OutVariable session

}

$sessions

# Enter an interactive session
Enter-PSSession -Session $sessions[0]

# Run a command
Invoke-Command -Session $sessions -ScriptBlock {Write-Host "Hello $(whoami) from PowerShell $($PSVersionTable.PSVersion.ToString()) $(hostname)" -ForegroundColor Green}

Invoke-Command -Session $sessions -FilePath C:\temp\script.ps1

# Clean-up
Get-PSSession | Remove-PSSession