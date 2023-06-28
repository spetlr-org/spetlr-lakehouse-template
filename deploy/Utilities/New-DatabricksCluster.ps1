function New-DatabricksCluster {
  param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $clusterName,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $nodeType = "Standard_F4s",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $sparkVersion = "11.3.x-scala2.12",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [bool]
    $enableElasticDisk = $true,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [int]
    $autoTerminationMinutes = 120,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [int]
    $minWorkers = 1,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [int]
    $maxWorkers = 8,

    [Parameter(Mandatory = $false)]
    [ValidateNotNull()]
    [hashtable]
    $environmentVariables = @{},

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $dataSecurityMode = "NONE",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('STANDARD', 'PHOTON')]
    [string]
    $runtimeEngine = "STANDARD",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [switch]
    $useSpotInstance = $false
  )

  $pysparkEnvironmentVariables = @{
    "PYSPARK_PYTHON" = "/databricks/python3/bin/python3"
  }

  $cluster = @{
    cluster_name            = $clusterName
    spark_version           = $sparkVersion
    node_type_id            = $nodeType
    driver_node_type_id     = $nodeType
    autotermination_minutes = $autoTerminationMinutes
    enable_elastic_disk     = $enableElasticDisk
    ssh_public_keys         = @()
    init_scripts            = @()
    spark_env_vars          = $pysparkEnvironmentVariables + $environmentVariables
    spark_conf              = @{
      "spark.sql.streaming.schemaInference"                         = $true;
      "spark.databricks.delta.preview.enabled"                      = $true;
      "spark.databricks.delta.schema.autoMerge.enabled"             = $true;
      "spark.databricks.io.cache.enabled"                           = $true;
      "spark.databricks.delta.merge.repartitionBeforeWrite.enabled" = $true;
      "spark.scheduler.mode"                                        = "FAIR";
    }
    data_security_mode      = $dataSecurityMode
    runtime_engine          = $runtimeEngine
    custom_tags             = @{}
    autoscale               = @{
      min_workers = $minWorkers
      max_workers = $maxWorkers
    }
  }

  if ($useSpotInstance) {
    $cluster.azure_attributes = @{
      first_on_demand = 1
      availability = "SPOT_WITH_FALLBACK_AZURE"
      spot_bid_max_price = -1
    }
  }
  else {
    $cluster.azure_attributes = @{
      first_on_demand = 1
      availability = "ON_DEMAND_AZURE"
      spot_bid_max_price = -1
    }
  }

  $clusters = ((databricks clusters list --output JSON | ConvertFrom-Json).clusters) | Where-Object { $_.cluster_name -eq $clusterName }

  if ($clusters.Count -eq 0) {
    Set-Content ./cluster.json ($cluster | ConvertTo-Json)
    Write-Host "    Creating $clusterName"
    $clusterId = ((databricks clusters create --json-file ./cluster.json) | ConvertFrom-Json).cluster_id
    Start-Sleep -Seconds 60
    Write-Host "    Created new cluster (ID=$clusterId)"
  }
  else {
    $clusterId = $clusters[0].cluster_id
    Write-Host "    $clusterName already exists (ID=$clusterId)"

    Set-Content ./cluster.json ($cluster + @{ cluster_id = $clusterId } | ConvertTo-Json)

    databricks clusters edit --json-file ./cluster.json

    Write-Host "    Updated existing cluster (ID=$clusterId)"
  }

  Remove-Item ./cluster.json

  return $clusterId
}