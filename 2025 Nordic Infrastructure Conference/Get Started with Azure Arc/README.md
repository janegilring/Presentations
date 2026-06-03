# Nordic Infrastructure Conference 2025 - Jan Egil Ring

## Session: Unleashing the Power of Hybrid Management with PowerShell & Azure Arc

Welcome to the resources page for my session at Nordic Infrastructure Conference 2025! This session explores the powerful combination of PowerShell and Azure Arc for hybrid cloud management, with practical demos and real-world examples.

## 📚 Key Resources

### Azure Arc Jumpstart

- **[Azure Arc Jumpstart](https://aka.ms/ArcJumpstart)**
  - The ultimate resource for Azure Arc scenarios, demos, and hands-on learning
  - Comprehensive guides for getting started with Azure Arc

- **[ArcBox](https://aka.ms/ArcBox)**
  - Fully automated Azure Arc demo environment
  - Ready-to-use sandbox for testing Arc scenarios

### Landing Zone Accelerators

- **[Azure Arc-enabled servers landing zone accelerator](https://docs.microsoft.com/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/)**
  - Enterprise-ready landing zone design for Arc-enabled servers
  - Best practices for scalable hybrid infrastructure deployment

### Microsoft Learn Documentation

- **[Work smarter with your Azure Local instances using Microsoft Copilot in Azure](https://learn.microsoft.com/en-us/azure/copilot/work-smarter-edge)**
  - Learn how to leverage Microsoft Copilot for Azure Local management
  - **Example prompts to try:**
    - "Summarize my Azure Local instances"
    - "Tell me more about the alerts"
    - "Generate a summary of my Arc Machines in subscription subName"

### Demo Repositories

- **[janegilring/AzureLocalDemo](https://github.com/janegilring/AzureLocalDemo)**
  - Comprehensive demo setup for Azure Local scenarios
  - **Key Features:**
    - Bicep templates for Azure Arc-enabled infrastructure deployment
    - Automated GitHub Actions workflows for CI/CD
    - Support for AKS Arc clusters with Linux and Windows node pools
    - VM deployment with custom and marketplace images
    - Complete networking setup with logical networks and static IPs
    - Azure Local host configuration and management

### Related Sessions & MicroHacks

- **[Unleashing the Power of Hybrid Mgmt with PowerShell & Azure Arc - PSConfEU 2025](https://github.com/microsoft/MicroHack/tree/main/03-Azure/01-03-Infrastructure/02_Hybrid_Azure_Arc_Servers)**
  - Extended session from PowerShell Conference Europe 2025
  - Deep dive into PowerShell Remoting via SSH, Run Command, and more

- **[MicroHack: Hybrid Azure Arc Servers](https://github.com/microsoft/MicroHack/tree/main/03-Azure/01-03-Infrastructure/02_Hybrid_Azure_Arc_Servers)**
  - Hands-on learning experience for Azure Arc servers

### Official Microsoft Resources

- **[Azure Arc for Servers Demo Guides](https://www.microsoft.com/en-us/download/details.aspx?id=101320)**
  - Series of official Microsoft guides for demonstrating Azure Arc for servers
  - Available from the Official Microsoft Download Center

## 🚀 Live Demos

### Demo 1: SSH Configuration for Arc-enabled Servers

Configure SSH access for Arc-enabled servers to enable Remote SSH connections in VS Code:

```powershell
# Configure SSH for Arc-enabled Server
$resourceGroup = "rg-arcbox-itpro"
$serverName = "ArcBox-Win2K25"
$localUser = "Administrator"
$configFile = "~\.ssh\$serverName"

# Export SSH configuration
$SshConfig = Export-AzSshConfig -ResourceGroupName $resourceGroup -Name $serverName -LocalUser $localUser -ResourceType Microsoft.HybridCompute/machines -ConfigFilePath $configFile

# Display and copy configuration
$SshConfig.ConfigString
Set-Clipboard -Value $SshConfig.ConfigString

# Add to SSH config file
Add-Content -Path "~\.ssh\config" -Value $SshConfig.ConfigString
```

### Demo 2: SSH and RDP Access to ArcBox Demo Machines

Connect to your Arc-enabled machines using Azure CLI:

```powershell
# RDP to Windows Arc-enabled server
az ssh arc --subscription "12345678-9b9d-4161-b2bf-8cc239506f82" --resource-group "rg-arcbox-itpro" --name "ArcBox-Win2K25" --local-user "Administrator" --rdp

# SSH to Linux Arc-enabled server
az ssh arc --subscription "12345678-9b9d-4161-b2bf-8cc239506f82" --resource-group "rg-arcbox-itpro" --name "Arcbox-Ubuntu-01"
```

### 💡 Want More Demos?

For additional usage instructions and advanced demos, check out **[ArcBox](https://aka.ms/ArcBox)** - your gateway to exploring more Azure Arc scenarios and capabilities!

## 🔧 Prerequisites

To follow along with the demos, ensure you have:

- Azure CLI installed and configured
- PowerShell 7+ with Az PowerShell modules
- Visual Studio Code with Remote SSH extension
- An Azure subscription with Arc-enabled servers

## 📞 Connect with Me

Feel free to reach out if you have questions about Azure Arc, PowerShell, or hybrid cloud management!

**LinkedIn:** [Jan Egil Ring](https://www.linkedin.com/in/janegilring)

---

Session materials and demos from Nordic Infrastructure Conference 2025