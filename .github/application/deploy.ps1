param (
  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string]
  $environmentName,

  [Parameter(Mandatory = $false)]
  [ValidateNotNullOrEmpty()]
  [string]
  $buildId = "0"
)

$repoRoot = (git rev-parse --show-toplevel)

Push-Location -Path $repoRoot




# Step 0 Build Dependencies
Write-Host "Now Installing Build Dependencies"
python -m pip install --upgrade pip
pip install -r requirements-deploy.txt

# Step 1 Build
Write-Host "Now Deploying"

. "$repoRoot/tools/set_lib_env.ps1" `
  -buildId "0" `
  -environmentName $environmentName

dbx deploy --deployment-file=src/jobs/all.yml.j2

Pop-Location

