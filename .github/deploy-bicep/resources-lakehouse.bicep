param databricksName string
param keyVaultName string
param location string
param resourceGroupName string
param resourceTags object
param dataLakeName string
param dataLakeContainers array

//#############################################################################################
//# Provision Databricks Workspace
//#############################################################################################

resource rsdatabricks 'Microsoft.Databricks/workspaces@2022-04-01-preview' = {
  name: databricksName
  location: location
  properties: {
    managedResourceGroupId: subscriptionResourceId('Microsoft.Resources/resourceGroups', '${resourceGroupName}Cluster')
  }
  tags: resourceTags
}


//#############################################################################################
//# Provision Keyvault
//#############################################################################################

resource kw 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  tags: resourceTags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    enabledForTemplateDeployment: true
    tenantId: tenant().tenantId
    accessPolicies: [
    ]
  }
}

//#############################################################################################
//# Provision Storage Account (data lake)
//#############################################################################################

resource staccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: dataLakeName
  location: location
  tags: resourceTags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    isHnsEnabled: true
    allowBlobPublicAccess: false
    encryption: {
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    supportsHttpsTrafficOnly: true
  }

  resource blobservice 'blobServices@2021-09-01' = {
    name: 'default'

    resource containersVar 'containers@2021-02-01' = [for container in dataLakeContainers: {
      name: '${container.name}'
      properties: {
        publicAccess: 'None'
      }
    }]
  }
}

