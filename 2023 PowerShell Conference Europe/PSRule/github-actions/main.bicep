resource sa 'Microsoft.Storage/storageAccounts@2022-09-01'= {
  name: 'test-storage-account'
  kind: 'StorageV2'
  location: 'northeurope'
  sku: {
    name: 'Standard_GRS'
  }
  properties: {
    allowBlobPublicAccess: true
    minimumTlsVersion: 'TLS1_2'
  }
}
