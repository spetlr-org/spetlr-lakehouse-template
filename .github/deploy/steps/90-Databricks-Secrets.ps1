###############################################################################################
# Import secrets from the Key vault (Warehouse) into Databricks Secrets
###############################################################################################
Write-Host "  Import Databricks secrets from Key vault $key (Warehouse)" -ForegroundColor Green

Copy-Keyvault-To-Databricks -keyVaultName $keyVaultName