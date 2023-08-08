

$repoRoot = (git rev-parse --show-toplevel)

Push-Location -Path $repoRoot


# Step 0 Build Dependencies
Write-Host "Now Installing Build Dependencies"
python -m pip install --upgrade pip
pip install -r requirements-deploy.txt

# Step 1 Build
Write-Host "Now Deploying"

dbx deploy --deployment-file=src/jobs/all.yml.j2

Pop-Location

