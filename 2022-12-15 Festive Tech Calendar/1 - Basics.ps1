<#
Windows PowerShell 5.1 is supported, although docs states: "PowerShell 7 and later is the recommended
PowerShell version for use with the Microsoft Graph PowerShell SDK on all platforms.""
#>

# Verify PowerShell version
$PSVersionTable

# Install module
Install-Module Microsoft.Graph -Force

# Update module. Per December 2022 version 1.18 was the latest.
Update-Module Microsoft.Graph

# GitHub - code, issues and releases
Start-Process https://github.com/microsoftgraph/msgraph-sdk-powershell/releases

# Connect/disconnect
Connect-MgGraph -UseDeviceAuthentication
Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All"

Disconnect-MgGraph