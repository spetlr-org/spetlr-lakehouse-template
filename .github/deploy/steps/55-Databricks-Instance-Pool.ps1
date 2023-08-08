###############################################################################################
# Initialize Databricks
###############################################################################################
Write-Host "Initialize Databricks Instance Pools" -ForegroundColor Green


Write-Host "  Provision Microsoft.Compute resource provider" -ForegroundColor DarkYellow
az provider register --namespace Microsoft.Compute

$name = "Standard L4s instances runtime"
Write-Host "  Creating: $name" -ForegroundColor DarkYellow

$computeClusterPoolId = New-DatabricksInstancePool `
  -name $name `
  -clusterNodeType "Standard_L8s" `
  -sparkVersion "11.3.x-scala2.12" `
  -maxCapacity 40

Throw-WhenError -output $computeClusterPoolId