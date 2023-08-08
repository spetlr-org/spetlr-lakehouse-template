
$repoRoot = (git rev-parse --show-toplevel)

Push-Location -Path $repoRoot


# Step 0 Build Dependencies
Write-Host "Now Installing Build Dependencies"
python -m pip install --upgrade pip
pip install -r requirements-deploy.txt

# Step 1 Build
Write-Host "Now Building"
.github/application/build.ps1

# Step 2: submit test
Write-Host "Now Submitting"

spetlr-test-job submit `
              --tests test/ `
              --tasks-from test/cluster/ `
              --cluster-file src/jobs/cluster_env.json `
              --requirements-file requirements-test.txt `
              --sparklibs-file src/jobs/sparklibs.json `
              --out-json test.json


# Step 3: wait for test
Write-Host "Now Waiting for test"

spetlr-test-job fetch --runid-json test.json

Pop-Location

