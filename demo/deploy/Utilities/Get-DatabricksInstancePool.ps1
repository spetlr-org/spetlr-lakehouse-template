function Get-DatabricksInstancePool {
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $poolId,
  
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $poolName
    )
  
    if (($poolId -eq "") -and ($poolName -eq "")) {
        Write-Error "Either poolId and poolName needs to be provided."
        throw
    }
  
    if (($poolId -ne "") -and ($poolName -ne "")) {
        Write-Error "Provide either poolId or poolName - not both."
        throw
    }
  
    if ($poolId) {
        $pools = ((databricks instance-pools list --output JSON | ConvertFrom-Json).instance_pools) | Where-Object { $_.instance_pool_id -eq $poolId }
  
        if ($pools.Count -eq 0) {
            Throw-WhenError -output "Pool with id $poolId does not exist"
        }
  
        $response = $pools[0]
    }
    else {
        $pools = ((databricks instance-pools list --output JSON | ConvertFrom-Json).instance_pools) | Where-Object { $_.instance_pool_name -eq $poolName }
  
        if ($pools.Count -eq 0) {
            Throw-WhenError -output "Pool with name $poolName does not exist"
        }
  
        $response = $pools[0]
    }
  
    return $response
}