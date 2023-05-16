param prefix string
param location string

@description('The resource ID of the subnet.')
param subnetId string

@description('The resource ID of the Cosmos Database.')
param resourceID string



resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: '${prefix}-privateEndpint'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: '${prefix}-privateLink'
        properties: {
          privateLinkServiceId: resourceID
          groupIds: [
            'SQL'
          ]
        }
      }
    ]
    subnet: {
      id: subnetId
    }
  }
}

