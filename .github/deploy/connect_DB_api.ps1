# This is the script that creates the entire deployment
# for readability it is split up into separate steps
# where we try to use meaningful names.
param (
  # spetlr doesn't use separate environments
  # see atc-snippets for more inspiration
  [Parameter(Mandatory=$false)]
  [ValidateNotNullOrEmpty()]
  [string]
  $environmentName=""
)

# get the true repository root
$repoRoot = (git rev-parse --show-toplevel)

# import utility functions
. "$repoRoot/.github/deploy/Utilities/all.ps1"

###############################################################################################
# Execute steps in order
###############################################################################################

. "$repoRoot/.github/deploy/steps/00-Verify-Arguments.ps1"
. "$repoRoot/.github/deploy/steps/10-Config.ps1"
. "$repoRoot/.github/deploy/steps/35-Provision-Service-Principal.ps1"
. "$repoRoot/.github/deploy/steps/50-Initialize-Databricks.ps1"

$dbSpn = ""
$mountSpn = ""
