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
. "$PSScriptRoot\utilities\integration_test\Submit-TestJob.ps1"
. "$PSScriptRoot\utilities\integration_test\Get-TestJob.ps1"

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
# Start tests
###############################################################################################
Write-Host "Start integration test" -ForegroundColor DarkGreen

Submit-TestJob

###############################################################################################
# Get test results
###############################################################################################
Write-Host "Get results from integration test" -ForegroundColor DarkGreen

Get-TestJob