


# get the true repository root
$repoRoot = (git rev-parse --show-toplevel)

# import utility functions
. "$repoRoot/.github/deploy/Utilities/all.ps1"




# Check that we are in a subscription that is correctly tagged
if(-not (Check-AzureAccountTag "spetlr-lakehouse-demo")){
    throw "Wrong subscription"
}


&"$repoRoot/.github/deploy/connect_DB_api.ps1" `
            -environmentName "dev"

. "$repoRoot/.github/application/deploy.ps1"