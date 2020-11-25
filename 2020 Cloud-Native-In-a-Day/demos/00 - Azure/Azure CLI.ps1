# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi

Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'

# getting help
az --help

# login
az login

# service principal
az login --service-principal -u "1234" --tenant "bb0f0b4e-4525-4e4b-ba50-1e7775a8fd2e"

az account show
az account list

# Workshop subscription
az account set -s "380d994a-e9b5-4648-ab8b-815e2ef18a2b"

# finding az commands
az find vm

# finding sub command help
az vm --help

# create a vm
az vm create -n azclidemovm -g demo-rg --image Win2016Datacenter --location norwayeast --size Standard_DS1_v2

# list all VMs
az vm list
az vm list --output table

# Azure CLI extensions
# list all extensions
az extension list-available

# list installed extensions
az extension list

# add extension
az extension add --name azure-devops

# upgrading extensions
az extension update -n interactive

# interactive CLI
az interactive

# CLI configuration
az configure --help
Get-Content -Path "$HOME\.azure\config"

# New in Az CLI 2.5.0 (2020 April)
az deployment group what-if
az deployment group create -c/--confirm-with-what-if