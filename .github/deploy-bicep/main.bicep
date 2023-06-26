// Setting target scope
targetScope = 'subscription'


param location string
param resourceTags string
param resourceGroupName string
param databricksName string
param keyVaultName string
param dataLakeName string
param datalakeContainers string


var myDataLakeContainers = json(datalakeContainers)
var myResouceTags = json(resourceTags)

// Creating integration resource group
module rgModule2 'rg-lakehouse.bicep' = {
  scope: subscription()
  name: '${resourceGroupName}-create'
  params: {
    name: resourceGroupName
    location: location
    tags: myResouceTags
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
    resourceTags: myResouceTags
    dataLakeName: dataLakeName
    dataLakeContainers: myDataLakeContainers
  }
}
