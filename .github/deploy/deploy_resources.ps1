# This is the script that creates the entire deployment
# for readability it is split up into separate steps
# where we try to use meaningful names.
param (
  # spetlr doesn't use separate environments
  # see atc-snippets for more inspiration
  [Parameter(Mandatory=$false)]
  [ValidateNotNullOrEmpty()]
  [string]
  $environmentName="",

  [Parameter(Mandatory=$false)]
  [ValidateNotNullOrEmpty()]
  [string]
  $pipelineClientId
)

# get the true repository root
$repoRoot = (git rev-parse --show-toplevel)

# import utility functions
. "$repoRoot/.github/deploy/Utilities/all.ps1"

###############################################################################################
# Execute steps in order
###############################################################################################

Get-ChildItem "$repoRoot/.github/deploy/steps" -Filter *.ps1 | Sort-Object name | Foreach-Object {
  . ("$_")
}
