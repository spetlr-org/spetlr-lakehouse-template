# This script sets up a number of constants.
# This step makes no call to any resource, and is therefore very fast.

# Important Paths
$repoRoot = (git rev-parse --show-toplevel)

# Naming rule configurations
$companyAbbreviation = "spetlr"
$systemName = "Demo"
$serviceName = "LakeHouse"
$systemAbbreviation = "lh"
$companyHostName = "spetlr.com"


# at some point, the following will be made variable between deployments
$resourceGroupName = Get-ResourceGroupName -systemName $systemName -environmentName $environmentName -serviceName $serviceName
$resourceName = Get-ResourceName -companyAbbreviation $companyAbbreviation -systemAbbreviation $systemAbbreviation -environmentName $environmentName


$databricksName               = $resourceName
$dataLakeName                 = $resourceName


# The SPN whose role will be used to access the storage account
$mountSpnName                 = "SpetlrLh${$ENV}MountSpn"

# This SPn will be used to deploy databricks
# The reason fo using a subsidiary SPN for this is that SPN can pull a databricks
# token from an API with no human in the loop. So if the identity that runs the
# deployment is a person, using this SPN allows us to still do this.
$dbDeploySpnName              = "SpetlrLh${$ENV}DbSpn"

# The SPN that runs the github pipeline
$cicdSpnName                  = "SpetlrLakehousePipe"



# Use eastus because of free azure subscription
# note, we no longer use a free subscription
$location                     = "westeurope"

$resourceTags = @{
  Owner='Auto Deployed'
  System='SPETLR-ORG'
  Service='LakeHouse'
  deployedAt="$(Get-Date -Format "o" -AsUTC)"
}
$resourceTags = ($resourceTags| ConvertTo-Json -Depth 4 -Compress)

$dataLakeContainers = (,@(@{"name"="capture"}))
$dataLakeContainersJson = ($dataLakeContainers | ConvertTo-Json -Depth 4 -Compress)


if ($IsLinux)
{
    $dataLakeContainersJson = $dataLakeContainersJson -replace '"', '\"'
    $resourceTags = $resourceTags -replace '"', '\"'
}

$keyVaultName = $resourceName


Write-Host "**********************************************************************" -ForegroundColor White
Write-Host "* Base Configuration       *******************************************" -ForegroundColor White
Write-Host "**********************************************************************" -ForegroundColor White
Write-Host "* Resource Group                  : $resourceGroupName" -ForegroundColor White
Write-Host "* Resource Name                   : $resourceName" -ForegroundColor White
Write-Host "* location                        : $location" -ForegroundColor White
Write-Host "* Azure Databricks Workspace      : $databricksName" -ForegroundColor White
Write-Host "* Azure Data Lake                 : $dataLakeName" -ForegroundColor White
Write-Host "* Mounting SPN Name               : $mountSpnName" -ForegroundColor White
Write-Host "* KeyVault name                   : $keyVaultName" -ForegroundColor White
Write-Host "**********************************************************************" -ForegroundColor White


