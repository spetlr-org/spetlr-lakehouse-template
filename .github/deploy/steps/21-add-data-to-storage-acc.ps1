Write-Host "  Preparing NYC Taxi dataset for upload..." -ForegroundColor Yellow

$datasetName = "data/NYC_TLC_dataset.csv"

$dataExists = az storage blob exists `
    --account-name $dataLakeName `
    --container-name "capture" `
    --name $datasetName `
    --query exists


if ($dataExists -ne "true") {
    Write-Host "  Upload NYC Taxi dataset as blob to $dataLakeName..." -ForegroundColor Yellow
    az storage blob upload `
        --account-name $dataLakeName `
        --container-name "capture" `
        --name $datasetName `
        --file "$repoRoot/data/NYC_TLC_dataset.csv" `
        --auth-mode login `
        --overwrite
    Write-Host "  Dataset succesfully uploadet!" -ForegroundColor Green
}
else {
    Write-Host "  Dataset already exists. Skip uploading..." -ForegroundColor Yellow
}
