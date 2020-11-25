# https://github.com/Azure/arm-ttk
git clone git@github.com:Azure/arm-ttk.git

cd C:\Users\janring\Git\arm-ttk\arm-ttk

Import-Module .\arm-ttk.psd1

Get-Command -Module arm-ttk

Test-AzTemplate -TemplatePath 'C:\Users\janring\Git\CrayonDevOpsWorkshop\demos\ARM templates\ARMTemplatesDeepDive\1.First\template.json'

