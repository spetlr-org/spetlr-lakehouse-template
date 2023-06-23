# The keyvault needed to exist before the SPNs were created. Therefore the SPNs don't have access, yet.

# To ensure that we can get SPN secrets from the keyvault, we set the role
if($pipelineClientId){

  $output = az keyvault set-policy --name $keyVaultName --secret-permissions get set list --spn $pipelineClientId

}else{

  # If this value is not set, you are a human. You probably have never been given access
  # to the keyvault.
  $myid = az ad signed-in-user show --query id --out tsv
  $output = az keyvault set-policy --name $keyVaultName --secret-permissions get set list --object-id "$myid"

}

