# Previous behaviour: StorageSync module was bundled with the Storage Sync Agent
# Import-Module "C:\Program Files\Azure\StorageSyncAgent\StorageSync.Management.PowerShell.Cmdlets.dll" -WarningAction SilentlyContinue

# New behaviour: Separate module for Az.StorageSync (likely to be included in the next Az-rollup module update)
Install-Module -Name Az.StorageSync

Get-Command -Module Az.StorageSync

# Credentials
$TenantId = 'xxxxx'
$SubscriptionId = 'xxxxx'
$AzureCredential = Import-Clixml -Path ~\azcred.xml

Connect-AzAccount -Credential $AzureCredential -Tenant $TenantId -Subscription $SubscriptionId

# Device Login
Connect-AzAccount
Set-AzContext -Subscription $SubscriptionId

# Variables
$location = "westeurope"
$AzureFileSyncResourceGroup = 'jer-psconfeu-rg'
$AzureFileSyncInstanceName = 'PSConfEU'
$syncGroupName = 'DemoData'
$HybridFileServerFQDN = 'BranchFS1.azurelab.local'
$serverEndpointPath = "D:\DemoData"
$volumeFreeSpacePercentage = 10

New-AzResourceGroup -Name $AzureFileSyncResourceGroup -Location $location

# Create storage account to host file share to host cloud endpoint

New-AzStorageAccount -ResourceGroupName $AzureFileSyncResourceGroup -Name hybridfileservers -Location $location -SkuName Standard_LRS -Kind StorageV2

$StorageAccountKey = (Get-AzStorageAccountKey -Name hybridfileservers -ResourceGroupName $AzureFileSyncResourceGroup | Where-Object KeyName -eq key1).Value

# Create Azure file share

$storageContext = New-AzStorageContext -StorageAccountName hybridfileservers -StorageAccountKey $StorageAccountKey
New-AzStorageShare -Context $storageContext -Name demodata

$storageAccount = Get-AzStorageAccount -ResourceGroupName $AzureFileSyncResourceGroup -Name hybridfileservers
$fileshare = Get-AzStorageShare -Context $storageContext -Name demodata

# Create storage sync service/instance

$StorageSyncServiceParameters = @{
    ResourceGroupName = $AzureFileSyncResourceGroup
    StorageSyncServiceName = $AzureFileSyncInstanceName
    Location = $location
}

New-AzStorageSyncService @StorageSyncServiceParameters

Get-AzStorageSyncService -ResourceGroupName $AzureFileSyncResourceGroup -StorageSyncServiceName $AzureFileSyncInstanceName


$StorageSyncGroupParameters = @{
    Name = $syncGroupName
    ResourceGroupName = $AzureFileSyncResourceGroup
    StorageSyncServiceName = $AzureFileSyncInstanceName
}

New-AzStorageSyncGroup @StorageSyncGroupParameters


# Create the cloud endpoint

$CloudEndpointParameters = @{
    Name = $fileShare.Name # When created through the Azure portal, Name is set to the name of the Azure file share it references.
    SyncGroupName = $syncGroupName
    ResourceGroupName = $AzureFileSyncResourceGroup
    StorageSyncServiceName = $AzureFileSyncInstanceName
    StorageAccountResourceId = $storageAccount.Id
    AzureFileShareName = $fileShare.Name
}

New-AzStorageSyncCloudEndpoint @CloudEndpointParameters

# Adding a server endpoint requires an agent to be deployed and registered
$registeredServer = Get-AzStorageSyncServer -StorageSyncServiceName $AzureFileSyncInstanceName -ResourceGroupName $AzureFileSyncResourceGroup | Where-Object FriendlyName -eq $HybridFileServerFQDN
$registeredServer.ResourceId

$SyncServerParameters = @{
    Name = $HybridFileServerFQDN
    StorageSyncServiceName = $AzureFileSyncInstanceName
    SyncGroupName = $syncGroupName
    ServerResourceId = $registeredServer.ResourceId
    ServerLocalPath = $serverEndpointPath
    CloudTiering = $true
    VolumeFreeSpacePercent = $volumeFreeSpacePercentage
    ResourceGroupName = $AzureFileSyncResourceGroup
}

# Create server endpoint
New-AzStorageSyncServerEndpoint @SyncServerParameters
