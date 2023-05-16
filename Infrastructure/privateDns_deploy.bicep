
param vnetResourceId string 
param prefix string



resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.documents.azure.com' // this is the zone you need to use, look this up in ms docs to see which one you need for your resource.
  location: 'global'
}

resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: '${prefix}-cosmos-dns-link'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetResourceId
    }
  }
  
  location: 'global'

}

@description('The resource ID of the CosmosSQL DataBase.')
output privateDnsZoneId string = privateDnsZone.id
