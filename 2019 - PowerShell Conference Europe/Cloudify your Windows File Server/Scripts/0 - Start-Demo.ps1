break #Safety net against running the script as a whole, it is meant to be run line by line

# Change to Git-repo
cd '~\Dropbox\Presentasjoner\PowerShell Conference\PSConfEU2019\Scripts - Azure File Sync\'

function Open-Website {
param ($URL)

    Start-Process -FilePath chrome.exe -ArgumentList $URL

}

# Documentation
Open-Website -URL 'https://docs.microsoft.com/en-us/azure/storage/files/storage-sync-files-deployment-guide?tabs=azure-portal'

# Setup and configuration
psedit '.\1 - Azure File Sync.ps1'

# Azure File Sync DSC module
psedit '.\2 - Azure File Sync DSC module.ps1'

# Compile configuration and upload to pull server
psedit '.\3 - DSC Pull Server.ps1'

# Azure File Sync DSC resource
Open-Website -URL 'https://github.com/janegilring/AzureFileSyncDsc'
Open-Website -URL 'https://dev.azure.com/janegilring/AzureFileSyncDsc'