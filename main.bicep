targetScope = 'subscription'

// General Parameters 
// =================
@description('The location to deploy resources to.')
param location string = 'uksouth'
@description('The Resource Group to deploy resources to.')
param vnetResourceGroupName string = 'lambda-toys-api-vnet' //change
@description('The Resource Group to deploy resources to.')
param infraResourceGroupName string = 'lambda-toys-api-infrastructure' //change
@description('The Name for Resources.')
param prefix string = 'labda-dev'

// Create Resource Group For Vnet
// =================================
resource labdaToysApi 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: vnetResourceGroupName
  location: location
}

// Create Resource Group For Infrastructure
// =================================
resource infrastructure 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: infraResourceGroupName
  location: location
}

// Create Virtual Network, Subnet, NSG
module Network './Infrastructure/vnet_deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-network-deployment'
  scope: resourceGroup(labdaToysApi.name)
  params: {
    location:location
    prefix: prefix
  }
}

//Create Cosmos DB
module Database './Infrastructure/database_deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-database-deployment'
  scope: resourceGroup(infrastructure.name)
  params: {
    location:location
    prefix: prefix
  }
}

// Create Private DNS Zone
module privateDNSZone './Infrastructure/privateDns_deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-nca-privatednszone-deployment'
  scope: resourceGroup(labdaToysApi.name)
  params: {
    prefix: prefix
    vnetResourceId: Network.outputs.virtualNetworkId
  }
}


// // Create Private Endpoint
 module privateEndpointDeploy './Infrastructure/endpoint_deploy.bicep' = {
   name: '${uniqueString(deployment().name, location)}-nca-privateendpoint-deployment'
   scope: resourceGroup(labdaToysApi.name)
   params: {
     prefix: prefix
     location: location
     resourceID: Database.outputs.cosmosResourceId
     subnetId: Network.outputs.subnet1Id
     privateDnsZoneId: privateDNSZone.outputs.privateDnsZoneId
   }
 }



