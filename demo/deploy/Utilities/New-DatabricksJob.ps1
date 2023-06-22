function New-DatabricksJob {
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
        $wheelEntryPoint,
  
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $wheelPackageName = "data_platform_demo",
  
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [object]
        $namedParameters = @{},
  
        [Parameter(Mandatory = $false)]
        [array]
        $libraries = @(),
  
        [Parameter(Mandatory = $false)]
        [string]
        $cronExpression,
  
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
        [bool]
        $enableElasticDisk = $true,
  
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]
        $numberOfWorkers = 0,
  
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]
        $minWorkers,
  
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]
        $maxWorkers,
  
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]
        $maxConcurrentRuns = 1,
  
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]
        $timeoutSeconds = 0,
  
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]
        $maxRetries = 1,
  
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $timezoneId = "UTC",
  
        [Parameter(Mandatory = $false)]
        [array]
        $emailRecipient = @(), #@("email1@customer.com", "email2@customer.com")
  
        [Parameter(Mandatory = $false)]
        [bool]
        $emailNotificationOnFailure = $false,
  
        [Parameter(Mandatory = $false)]
        [bool]
        $emailNotificationOnStart = $false,
  
        [Parameter(Mandatory = $false)]
        [bool]
        $emailNotificationOnSuccess = $false,
  
        [Parameter(Mandatory = $false)]
        [switch]
        $runAsContinuousStreaming,
  
        [Parameter(Mandatory = $false)]
        [switch]
        $runNow
    )
  
    $job = @{
        name                = $name
        max_concurrent_runs = $maxConcurrentRuns
        timeout_seconds     = $timeoutSeconds
        max_retries         = $maxRetries
        email_notifications = @{ }
        libraries           = $libraries
    }
  
    if ($notebookPath) {
        $job.notebook_task = @{
            revision_timestamp = 0
            notebook_path      = $notebookPath
            base_parameters    = $notebookParameters
        }
    }
  
    if ($wheelEntryPoint) {
        $job.python_wheel_task = @{
            package_name     = $wheelPackageName
            entry_point      = $wheelEntryPoint
            named_parameters = $namedParameters
        }
    }
  
    if ($runAsContinuousStreaming) {
        $job.max_concurrent_runs = 1
        $job.timeout_seconds = 0
        $job.max_retries = -1
    }
  
    if ($emailNotificationOnStart) {
        $job.email_notifications.on_start = $emailRecipient
    }
    if ($emailNotificationOnSuccess) {
        $job.email_notifications.on_success = $emailRecipient
    }
    if ($emailNotificationOnFailure) {
        $job.email_notifications.on_failure = $emailRecipient
    }
  
    if ($clusterId) {
        $job.existing_cluster_id = $clusterId
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
            "JobName" = $name
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
  
        $job.new_cluster = @{
            spark_version  = $sparkVersion
            spark_env_vars = $environmentVariables
            spark_conf     = $sparkConfig
            custom_tags    = $customTags
        }
  
        if ($minWorkers -gt 0 -And $maxWorkers -gt 1) {
            $job.new_cluster.autoscale = @{
                min_workers = $minWorkers
                max_workers = $maxWorkers
            }
        }
        else {
            $job.new_cluster.num_workers = $numberOfWorkers
        }
  
        if ($clusterPoolId) {
            $job.new_cluster.instance_pool_id = $clusterPoolId
        }
        else {
            $job.new_cluster.node_type_id = $clusterNodeType
            $job.new_cluster.enable_elastic_disk = $enableElasticDisk
        }
    }
  
    if ($cronExpression) {
        $job.schedule = @{
            timezone_id            = $timezoneId
            quartz_cron_expression = $cronExpression
        }
    }
  
    Set-Content ./job.json ($job | ConvertTo-Json -Depth 10)
  
    $json = databricks jobs list --version 2.1 --output JSON --all
    Throw-WhenError -output $json
    $jobs = (($json | ConvertFrom-Json).jobs)
    
    if ($jobs.Count -eq 0) {
        Write-Host "    Creating job with name '$name'"
        $json = databricks jobs create --json-file ./job.json
        Throw-WhenError -output $json
        $jobId = ($json | ConvertFrom-Json).job_id
    }
    elseif ($jobs.Count -eq 1) {
        Write-Host "    Found an existing job with name '$name'; overwriting it"
        $jobId = $jobs[0].job_id;
        $output = databricks jobs reset --job-id $jobId --json-file ./job.json
        Throw-WhenError -output $output
    }
    elseif ($jobs.Count -gt 1) {
        Write-Host "  Found multiple existing job with name '$name'; deleteing them"
        foreach ($job in $jobs) {
            $jobId = $job.job_id
      
            databricks jobs delete --job-id $jobId
        }
  
        Write-Host "    Creating job with name '$name'"
        $json = databricks jobs create --json-file ./job.json
        Throw-WhenError -output $json
        $jobId = ($json | ConvertFrom-Json).job_id
    }
  
    Write-Host (Get-Content -Path ./job.json) -ForegroundColor DarkCyan
  
    Remove-Item ./job.json
  
    if ($runNow) {
        if ($runAsContinuousStreaming) {
            Start-DatabricksJob -jobId $jobId -name $name -waitForCompletion $false -restartIfRunning $true
        }
        else {
            Start-DatabricksJob -jobId $jobId -name $name
        }
    }
}