break #Safety net against running the script as a whole, it is meant to be run line by line

# Change to Git-repo
cd '~\Presentations\PowerShell Conference\PSConfEU2019\Scripts - Azure File Sync\'

function Open-Website {
param ($URL)

    Start-Process -FilePath chrome.exe -ArgumentList $URL

}

# Documentation
Open-Website -URL 'https://docs.microsoft.com/en-us/azure/storage/files/storage-sync-files-deployment-guide?tabs=azure-portal'

# Azure File Sync DSC resource
Open-Website -URL 'https://dev.azure.com/janegilring/AzureFileSyncDsc'

