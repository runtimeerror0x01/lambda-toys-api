
param location string

param prefix string

param vnetsettings object = {
  addressPrefixes: [
    '10.0.0.0/19'
  ]
    subnets:[ //use visual subnet calculator. www.davidc.net/sites/default/subnets/subnets.html
   {
     name: 'subnet1'
     addressPrefix: '10.0.0.0/21'
   }
   {
    name: 'acaAppSubnet'
    addressPrefix: '10.0.8.0/21'
  }
  {
    name: 'acaControlPlanSubnet'
    addressPrefix: '10.0.16.0/21'
  }

 ]
}
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name:'${prefix}-default-nsg'
  location: location
  properties: {
    securityRules: [   

    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: '${prefix}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetsettings.addressPrefixes
    }
    subnets: [ for subnet in vnetsettings.subnets:{
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
          networkSecurityGroup: {
            id:networkSecurityGroup.id
           }
          // privateEndpointNetworkPolicies: 'disabled'    
      }
   } ]
  }
}

@description('The resource ID of the virtual network.')
output virtualNetworkId string = virtualNetwork.id
@description('The resource ID of the Subnet.')
output subnet1Id string = virtualNetwork.properties.subnets[0].id
@description('The resource ID of the Subnet.')
output acaAppSubnet string = virtualNetwork.properties.subnets[1].id
@description('The resource ID of the Subnet.')
output acaControlPlanSubnet string = virtualNetwork.properties.subnets[2].id
