param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $DatabricksName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Token
)

#############################################################################################
# Import Utility Functions
#############################################################################################

. "$PSScriptRoot\Utilities\Throw-WhenError.ps1"
. "$PSScriptRoot\Utilities\New-DatabricksCluster.ps1"
. "$PSScriptRoot\Utilities\New-DatabricksJob.ps1"

#############################################################################################
# Installing Databricks CLI
#############################################################################################

Write-Host "  Installing Databricks CLI" -ForegroundColor DarkYellow
pip install --upgrade pip --quiet
pip install --upgrade databricks-cli --quiet

###############################################################################################
# Initialize Databricks
###############################################################################################
Write-Host "Initialize Databricks Configuration" -ForegroundColor DarkGreen

Write-Host "  Get resource id" -ForegroundColor DarkYellow
$workspaceUrl = az resource show `
    --resource-group $ResourceGroupName `
    --name $DatabricksName `
    --resource-type "Microsoft.Databricks/workspaces" `
    --query properties.workspaceUrl `
    --output tsv

Throw-WhenError -output $workspaceUrl

Write-Host "  Generating .databrickscfg" -ForegroundColor DarkYellow
Set-Content ~/.databrickscfg "[DEFAULT]"
Add-Content ~/.databrickscfg "host = https://$workspaceUrl"
Add-Content ~/.databrickscfg "token = $token"
Add-Content ~/.databrickscfg ""

databricks jobs configure --version=2.1

###############################################################################################
# Deploy clusters
###############################################################################################
Write-Host "  Create databricks clusters" -ForegroundColor DarkYellow

$defaultClusterId = New-DatabricksCluster `
    -clusterName "DefaultCluster" `
    -nodeType "Standard_D4ds_v5" `
    -sparkVersion "11.3.x-scala2.12" `
    -autoTerminationMinutes 60 `
    -minWorkers 1 `
    -maxWorkers 2 `
    -useSpotInstance

Throw-WhenError -output $defaultClusterId

###############################################################################################
# Deploy Dataplatform Python Library
###############################################################################################

$pythonLibraryWheelWheelFile = Get-ChildItem "$PSScriptRoot/../dist/data_platform_demo-1.0-py3-none-any.whl"
$pythonLibraryWheelPath = "dbfs:/FileStore/jars/python/data_platform_demo/" + $pythonLibraryWheelWheelFile.Name

Write-Host "  Moving $($pythonLibraryWheelWheelFile.FullName) to $($pythonLibraryWheelPath)" -ForegroundColor DarkYellow
databricks fs cp --overwrite $pythonLibraryWheelWheelFile.FullName $pythonLibraryWheelPath

Write-Host "  Install Libraries on DefaultCluster" -ForegroundColor DarkYellow
databricks libraries install --cluster-id $defaultClusterId --whl $pythonLibraryWheelPath

###############################################################################################
# Deploy job
###############################################################################################

New-DatabricksJob `
    -name "Demo elt job" `
    -wheelEntryPoint "demo_elt" `
    -clusterId $defaultClusterId `
    -libraries @(
    @{ whl = $pythonLibraryWheelPath }
)