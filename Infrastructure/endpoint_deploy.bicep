param prefix string
param location string
@description('The resource ID of the subnet.')
param subnetId string
@description('The resource ID of the Cosmos Database.')
param resourceID string
@description('The resource ID of the Private DNS Zone.')
param privateDnsZoneId string


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
            'SQL' // subresource where private endpoint gets attached to, here we use sql api from SQL, MongoDB, Cassandra, Gremlin, Table.
                  // more endpoints will be need for more api connections.
          ]
        }
      }
    ]
    subnet: {
      id: subnetId
    }
  }
}

resource cosmosPrivateendpointDnsLink 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  name: '${prefix}-cosmos-pe-dns'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink.documents.azure.com'
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
  // dependsOn: [
  //   privateEndpoint
  // ]
}
