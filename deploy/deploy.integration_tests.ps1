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
    $TenantId,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $authAppId,

    [Parameter(Mandatory = $false)]
    [string]
    $TestDirectory
)

#############################################################################################
# Import Utility Functions
#############################################################################################

. "$PSScriptRoot\Utilities\Throw-WhenError.ps1"

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


$token = (az_databricks_token `
        --tenantId $tenantId `
        --appId $authAppId )


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

Push-Location -Path "$PSScriptRoot/../"

if ($TestDirectory) {
    spetlr-test-job submit `
        --tests "test/" `
        --task $TestDirectory `
        --cluster-file "deploy/conf/cluster113.json" `
        --requirements-file "test/cluster/test_requirements.txt" `
        --sparklibs-file "deploy/conf/sparklibs.json" `
        --out-json test_job_details.json
}
else {
    spetlr-test-job submit `
        --tests "test/" `
        --tasks-from "test/integration/" `
        --cluster-file "deploy/conf/cluster113.json" `
        --requirements-file "test/cluster/test_requirements.txt" `
        --sparklibs-file "deploy/conf/sparklibs.json" `
        --out-json test_job_details.json
}

###############################################################################################
# Get test results
###############################################################################################
Write-Host "Get results from integration test" -ForegroundColor DarkGreen

spetlr-test-job fetch --runid-json test_job_details.json

Pop-Location