
Write-Host "Verifying powershell arguments" -ForegroundColor DarkGreen

if (!$tenantId) {
  $tenantId = (az account show --query tenantId --out tsv)
}

# Allow dynamic install of extensions to be able to use az databricks commands
az config set extension.use_dynamic_install=yes_without_prompt

if(!$environmentName){
   throw 'You have to name your environment. $environmentName not set'
}