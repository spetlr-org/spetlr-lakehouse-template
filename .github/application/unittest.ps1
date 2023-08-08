
$repoRoot = (git rev-parse --show-toplevel)

Push-Location -Path $repoRoot


# Step 0 Build Dependencies
Write-Host "Now Installing Test Dependencies"
python -m pip install --upgrade pip
pip install -r requirements-deploy.txt
pip install -r requirements-test.txt

# Step 0 Build Dependencies
Write-Host "Now Running Local Unit Test"
python -m pytest test/local

Pop-Location