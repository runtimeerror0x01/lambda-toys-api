
param location string

param prefix string

param vnetsettings object = {
  addressPrefixes: [
    '10.0.0.0/20'
  ]
    subnets:[
   {
     name: 'subnet1'
     addressPrefix: '10.0.0.0/20'
  
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
          addressPrefixes: subnet.addressPrefix
          networkSecurityGroup: {
            id:networkSecurityGroup.id
           }
      }
   } ]
  }
}


