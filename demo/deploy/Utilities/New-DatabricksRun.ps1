function New-DatabricksRun {
  param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $name,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $notebookPath,

    [Parameter(Mandatory = $false)]
    [object]
    $notebookParameters = @{},

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $pythonFilePath,

    [Parameter(Mandatory = $false)]
    [object]
    $pythonFileParameters = @(),

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $wheelEntryPoint,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $wheelPackageName = "data_platform_databricks",

    [Parameter(Mandatory = $false)]
    [array]
    $libraries = @(),

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $clusterId,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $clusterNodeType = "Standard_F4s",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $clusterPoolId,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $sparkVersion = "11.3.x-scala2.12",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [int]
    $numberOfWorkers = 0,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $clusterLogDestination
  )

  $run = @{
    run_name  = $name
    libraries = $libraries
  }

  if ($notebookPath) {
    $run.notebook_task = @{
      revision_timestamp = 0
      notebook_path      = $notebookPath
      base_parameters    = $notebookParameters
    }
  }

  if ($pythonFilePath) {
    $run.spark_python_task = @{
      python_file = $pythonFilePath
      parameters  = $pythonFileParameters
    }
  }
  
  if ($wheelEntryPoint) {
    $run.python_wheel_task = @{
      package_name = $wheelPackageName
      entry_point  = $wheelEntryPoint
    }
  }

  if ($clusterId) {
    $run.existing_cluster_id = $clusterId
  }
  else {
    $environmentVariables = @{
      "PYSPARK_PYTHON" = "/databricks/python3/bin/python3"
    }

    $sparkConfig = @{
      "spark.sql.streaming.schemaInference"                         = $true;
      "spark.databricks.delta.preview.enabled"                      = $true;
      "spark.databricks.delta.schema.autoMerge.enabled"             = $true;
      "spark.databricks.io.cache.enabled"                           = $true;
      "spark.databricks.delta.merge.repartitionBeforeWrite.enabled" = $true;
      "spark.scheduler.mode"                                        = "FAIR";
    }

    $customTags = @{
      "RunName" = $name
    }

    if ($numberOfWorkers -eq 0) {
      $sparkConfig = $sparkConfig + @{
        "spark.databricks.cluster.profile" = "singleNode";
        "spark.master"                     = "local[*]";
      }
      $customTags = $customTags + @{
        "ResourceClass" = "SingleNode"
      }
    }

    $run.new_cluster = @{
      spark_version  = $sparkVersion
      spark_env_vars = $environmentVariables
      spark_conf     = $sparkConfig
      custom_tags    = $customTags
    }

    $run.new_cluster.num_workers = $numberOfWorkers

    if ($clusterPoolId) {
      $run.new_cluster.instance_pool_id = $clusterPoolId
    }
    else {
      $run.new_cluster.node_type_id = $clusterNodeType
      $run.new_cluster.enable_elastic_disk = $enableElasticDisk
    }

    if ($clusterLogDestination) {
      $run.cluster_log_conf = @{
        dbfs = @{destination = $clusterLogDestination }
      }
    }
  }

  Set-Content ./run.json ($run | ConvertTo-Json -Depth 10)

  $json = databricks runs submit --json-file ./run.json
  Throw-WhenError -output $json
  $runId = ($json | ConvertFrom-Json).run_id

  Remove-Item ./run.json

  return $runId
}