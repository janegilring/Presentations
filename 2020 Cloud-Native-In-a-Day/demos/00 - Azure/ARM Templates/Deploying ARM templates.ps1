Connect-AzAccount

Set-AzContext -Subscription 'workshop-subscription'

Start-Process 'https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-syntax'

# ARMTemplatesDeepDive demos by Nils Hedström
# https://github.com/nilshedstrom/ARMTemplatesDeepDive/

# Option 1: Create resource manually in the portal, export template and customize

Start-Process 'https://portal.azure.com/#'

$TemplateFile = "C:\Users\janring\Downloads\ExportedTemplate-jer-networking-rg\template.json"
$TemplateParameterFile = 'C:\Users\janring\Downloads\ExportedTemplate-jer-networking-rg\parameters.json'

psedit $TemplateFile
psedit $TemplateParameterFile

New-AzResourceGroup -Name ARMDemo -Location westeurope

New-AzResourceGroupDeployment -Name ARMDemo -ResourceGroupName ARMDemo `
    -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile

# Clean up demo
Remove-AzResourceGroup -Name ARMDemo -Force

# Option 2: Quick Start template

Start-Process 'https://azure.microsoft.com/en-us/resources/templates/'
Start-Process 'https://azure.microsoft.com/en-us/resources/templates/docker-simple-on-ubuntu/'
Start-Process 'https://github.com/Azure/azure-quickstart-templates'

cd ~\Git
git clone git@github.com:Azure/azure-quickstart-templates.git

$TemplateFile = "~\Git\azure-quickstart-templates\docker-simple-on-ubuntu\azuredeploy.json"
$TemplateParameterFile = "~\Git\azure-quickstart-templates\docker-simple-on-ubuntu\azuredeploy.parameters.json"

psedit $TemplateFile
psedit $TemplateParameterFile

New-AzResourceGroup -Name ARMDemo -Location westeurope

# WhatIf is currently in preview
Start-Process "https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-deploy-what-if?tabs=azure-powershell"

New-AzResourceGroupDeployment -Name ARMDemo -ResourceGroupName ARMDemo `
    -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile -WhatIf

    New-AzResourceGroupDeployment -Name ARMDemo -ResourceGroupName ARMDemo `
    -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile -Confirm

    New-AzResourceGroupDeployment -Name ARMDemo -ResourceGroupName ARMDemo `
    -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile -Confirm -Mode Complete

    # Since WhatIf is currently in preview, we must install prerelease-version
    Install-Module -Name Az.Resources -AllowPrerelease -RequiredVersion 2.0.1

    Import-Module Az.Resources -RequiredVersion 2.0.1

# Clean up demo
Remove-AzResourceGroup -Name ARMDemo -Force

New-AzResourceGroup -Name ARMWhatIfDemo -Location westeurope

$WhatIf = Get-AzResourceGroupDeploymentWhatIf -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile -ResourceGroupName ARMWhatIfDemo

$WhatIf.Changes
$WhatIf.Changes.ChangeType
$WhatIf.Status
$WhatIf.Error

Get-AzSubscriptionDeploymentWhatIf

# This will return an object to enable programmatic analysis of the response (e.g. are there any resources to be deleted, how many properties are changing, etc.)

# Clean up demo
Remove-AzResourceGroup -Name ARMWhatIfDemo -Force


# Option 3: Write template from scratch. Editors such as VS Code provides an extension for ARM Templates which provides Intellisense.

$DemoFile = New-Item -Name ManualArmDemo.json -Path $env:temp
New-Item -Name ManualArmDemo.parameters.json -Path $env:temp

# After opening the file, make sure to change Language Mode from JSON to Azure Resource Manager template in the bottom right corner
psedit $DemoFile.FullName

<#

Useful tips when working inside the template file:
1) Use ARM Template Outline on the left
2) Use Snippets to insert starting points by pressing Ctrl + Space

#>

New-AzResourceGroup -Name ARMManualDemo -Location westeurope

# Insert values after creating example file manually
$TemplateFile = "C:\users\janring\appdata\local\temp\manualarmdemo.json"
$TemplateParameterFile = "C:\users\janring\appdata\local\temp\manualarmdemo.parameters.json"

psedit $TemplateParameterFile

New-AzResourceGroupDeployment -Name ARMManualDemo -ResourceGroupName ARMManualDemo `
-TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile -Confirm

# Clean up demo
Remove-AzResourceGroup -Name ARMManualDemo -Force