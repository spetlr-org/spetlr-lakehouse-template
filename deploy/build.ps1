$srcDir = "$PSScriptRoot/../"

Push-Location -Path $srcDir

# we want a really clean build (even locally)
if (Test-Path -Path dist) {
  Remove-Item -Force -Recurse dist
}

if (Test-Path -Path build) {
  Remove-Item -Force -Recurse build
}

if (Test-Path -Path src\data_platform_databricks.egg-info) {
  Remove-Item -Force -Recurse src\data_platform_databricks.egg-info
}

pyclean .
python setup_with_entry_points.py bdist_wheel
pyclean .

Pop-Location