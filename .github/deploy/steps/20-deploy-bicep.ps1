
Write-Host "  Deploying ressources using Bicep..." -ForegroundColor Yellow


$output = az deployment sub create `
  --location "$location" `
  --template-file "$repoRoot/.github/deploy-bicep/main.bicep" `
  --parameters `
      location="$location" `
      keyVaultName="$keyVaultName" `
      resourceTags="`"$resourceTags`"" `
      resourceGroupName="$resourceGroupName" `
      databricksName="$databricksName" `
      dataLakeName="$dataLakeName" `
      datalakeContainers="`"$dataLakeContainersJson`""


Throw-WhenError -output $output

Write-Host "  Ressources deployed!" -ForegroundColor Green
