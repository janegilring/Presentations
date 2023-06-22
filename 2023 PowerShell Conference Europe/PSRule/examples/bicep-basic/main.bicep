resource sa 'Microsoft.Storage/storageAccounts@2022-09-01'= {
  name: 'test'
  kind: 'StorageV2'
  location: 'northeurope'
  sku: {
    name: 'Standard_LRS'
  }
}
