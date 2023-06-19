param location string = resourceGroup().location
param allocationMethod string
param pubIPName string
param skuName string

resource publicIP 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name:  pubIPName
  location: location
  sku: {
    name:  skuName
    tier:  'Regional'
  }
  properties: {
    publicIPAllocationMethod: allocationMethod
  }
}
