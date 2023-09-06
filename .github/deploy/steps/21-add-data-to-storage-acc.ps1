Write-Host "  Preparing NYC Taxi dataset for upload..." -ForegroundColor Yellow
Write-Host "    Add pipe spn as contributor to resourcegroup..." -ForegroundColor Yellow
$spnPipeObject = Graph-GetSpn -queryDisplayName $cicdSpnName

$output = az role assignment create `
    --role "Storage Blob Data Contributor" `
    --assignee-principal-type ServicePrincipal `
    --assignee-object-id $spnPipeObject.id `
    --resource-group $resourceGroupName

Throw-WhenError -output $output

$datasetName = "data/NYC_TLC_dataset.csv"

$dataExists = az storage blob exists `
    --account-name $dataLakeName `
    --container-name "capture" `
    --name $datasetName `
    --query exists


if ($dataExists -ne "true") {
    Write-Host "  Upload NYC Taxi dataset as blob to $dataLakeName..." -ForegroundColor Yellow
    $output = az storage blob upload `
        --account-name $dataLakeName `
        --container-name "capture" `
        --name $datasetName `
        --file "$repoRoot/data/NYC_TLC_dataset.csv" `
        --auth-mode login `
        --overwrite
    Write-Host "  Dataset succesfully uploadet!" -ForegroundColor Green

    Throw-WhenError -output $output
}
else {
    Write-Host "  Dataset already exists. Skip uploading..." -ForegroundColor Yellow
}
