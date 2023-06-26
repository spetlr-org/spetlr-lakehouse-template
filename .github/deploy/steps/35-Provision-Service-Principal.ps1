# This step provisions all service principals.
# The following SPN are used:
#  - SpetlrLakehousePipe - Not provisioned here.
#      Created in the separate script setup_deploying_SPN.ps1, this SPN is supposed to
#      act as close as possible to the the human that may want to run this pipeline.
#      Keeping this 1-1 correspondence take some effort because SPNs can do some things
#      that humans cannot. It is up to the developer to avoid these problems. The
#      benefit of this design philosophy is that the entire pipeline can be tested
#      locally.
#  - SpetlrDbSpn
#      This SPN is made a contributor to the resource group. With this right,
#      the SPN can pull an access token to deploy jobs etc to databricks. This is not
#      possible for humans. Keeping with the design principle above, we do not use the
#      deploying SPN for this.
#  - SpetlrMountSpn
#      This SPN is used to access to the storage account.
#      The secret of this SPN is exposed inside databricks where mistakes or malicious
#      behavior may expose it.
#      With this secret, an attacker must not gain the ability to deploy jobs or
#      resources, hence the restricted rights.
#
# Both the SpetlrDbSpn and the SpetlrMountSpn exists only once across multiple runs, which is
# why we try to persist and reuse their secrets.

$dbSpn = Get-SpnWithSecret -spnName $dbDeploySpnName -keyVaultName $keyVaultName
# this Spn is contributor and can create resources. Its secret should not be exposed
# inside databricks

$mountSpn = Get-SpnWithSecret -spnName $mountSpnName -keyVaultName $keyVaultName

Set-KeyVaultSecret -key "Databricks--TenantId" -value $tenantId -keyVaultName $keyVaultName
Set-KeyVaultSecret -key "Databricks--ClientId" -value $mountSpn.clientId -keyVaultName $keyVaultName
Set-KeyVaultSecret -key "Databricks--ClientSecret" -value $mountSpn.secretText -keyVaultName $keyVaultName

