// Setting target scope
targetScope = 'subscription'


param location string
param resourceTags object
param resourceGroupName string
param databricksName string
param keyVaultName string
param dataLakeName string
param datalakeContainers array


// Creating integration resource group
module rgModule2 'rg-lakehouse.bicep' = {
  scope: subscription()
  name: '${resourceGroupName}-create'
  params: {
    name: resourceGroupName
    location: location
    tags: resourceTags
  }
}

// Creating integration resources
module resources2 'resources-lakehouse.bicep' = {
  name: '${resourceGroupName}-resources-deployment'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [ rgModule2 ]
  params: {
    databricksName: databricksName
    keyVaultName: keyVaultName
    location: location
    resourceGroupName: resourceGroupName
    resourceTags: resourceTags
    dataLakeName: dataLakeName
    dataLakeContainers: datalakeContainers
  }
}
