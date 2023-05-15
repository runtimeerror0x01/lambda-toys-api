targetScope = 'subscription'

// General Parameters 
// =================
@description('The location to deploy resources to.')
param location string = 'uksouth'
@description('The Resource Group to deploy resources to.')
param resourceGroupName string = 'lambda-toys-api' //change

param prefix string = 'labda-toys-api'

// Create New Resource Group 
// =================================
resource labdaToysApi 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

// Create Virtual Network, Subnet, NSG
module Network './Infrastructure/core.bicep' = {
  name: '${uniqueString(deployment().name, location)}-network-deployment'
  scope: resourceGroup(labdaToysApi.name)
  params: {
    location:location
    prefix: prefix
  }
}







