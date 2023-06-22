function Submit-TestJob {
    param (
        # to submit parallel runs, you must specify this parameter
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $TestJobDetails = "test_job_details.json"
    )

    $srcDir = "$PSScriptRoot/../../../"
    $testDir = "$srcDir/test"

    $testJobDetailsPath = "$PSScriptRoot/$TestJobDetails"

    # import utility functions
    . "$srcDir/deploy/utilities/New-DatabricksRun.ps1"
    . "$srcDir/deploy/utilities/Get-DatabricksInstancePool.ps1"

    # start time of this script for job details
    $now = (Get-Date -Format yyyy-MM-ddTHH.mm)

    # for separating tasks, we will do everything in our own dir (allows parallel jobs):
    $databricksTestDir = "dbfs:/test/$([guid]::NewGuid())"
    dbfs mkdirs $databricksTestDir

    # Dependencies for integration test
    $sparkDependencies = @(@{ pypi = @{package = "atc-dataplatform-tools" } })

    # discover libraries in the dist folder
    $libs = Get-ChildItem -Path "$srcDir/dist" -Filter *.whl | ForEach-Object -Member name
    Write-Host "  Whl's to be installed on cluster: $($libs -join ", ")" -ForegroundColor DarkYellow

    $sparkWheels = $libs | ForEach-Object -Process { @{whl = "$databricksTestDir/dist/$_" } }
    $sparkDependencies = $sparkDependencies + $sparkWheels

    # upload the library
    dbfs cp -r --overwrite  "$srcDir/dist" "$databricksTestDir/dist"

    # upload the test main file
    dbfs cp --overwrite  "$PSScriptRoot/main.py" "$databricksTestDir/main.py"

    pip install pyclean
    pyclean $testDir # remove *.pyc and __pycache__
    
    # upload all tests
    dbfs cp --overwrite -r $testDir "$databricksTestDir/tests"

    # remote path of the log
    $logOut = "$databricksTestDir/results.log"

    $parameters = @(
        # running in the spark python interpreter, the python __file__ variable does not
        # work. Hence, we need to tell the script where the test area is.
        "--basedir=$databricksTestDir",
        # we can actually run any part of out test suite, but some files need the full repo.
        # Only run tests from this folder.
        "--folder=tests"
    )

    $runId = New-DatabricksRun `
        -name "Testing Run" `
        -pythonFilePath "$databricksTestDir/main.py" `
        -pythonFileParameters $parameters `
        -libraries $sparkDependencies `
        -clusterPoolId $((Get-DatabricksInstancePool -poolName "my_demo_pool").instance_pool_id) `
        -clusterLogDestination "$databricksTestDir/cluster-logs"

    # report on status
    Write-Host "  Started Run with ID $runId" -ForegroundColor DarkYellow
    Write-Host "  Using test dir $databricksTestDir" -ForegroundColor DarkYellow

    $run = (databricks runs get --run-id $runId | ConvertFrom-Json)
    Write-Host "  Run url: $($run.run_page_url)" -ForegroundColor DarkYellow

    # Roll the test details. When testing locally, this makes it easier to recover old runs.
    if (Test-Path -Path $testJobDetailsPath -PathType Leaf) {
        $old_job_details = Get-Content $testJobDetailsPath | ConvertFrom-Json
        $new_filename = "$(Split-Path -LeafBase $testJobDetailsPath).$($old_job_details.submissionTime).json"
        $parent = Split-Path -Parent $testJobDetailsPath
        if ($parent) {
            $new_filename = Join-Path -Path $parent -ChildPath $new_filename
        }
        Set-Content "$new_filename" ($old_job_details | ConvertTo-Json -Depth 4)
        Write-Host "  Previous details at $testJobDetailsPath were moved to $new_filename." -ForegroundColor DarkYellow
    }

    # write the test details file
    $job_details = @{
        runId             = $runId
        databricksTestDir = $databricksTestDir
        submissionTime    = $now
        testFolder        = $testFolder
        environmentType   = $environmentType
        environmentName   = $environmentName
        logOut            = $logOut
    }
    Set-Content "$testJobDetailsPath" ($job_details | ConvertTo-Json -Depth 4)

    Write-Host "  Test job details written to $testJobDetailsPath" -ForegroundColor DarkYellow
    Write-Host "  You can now use fetch_test_job.ps1 to check and collect the result of your test run." -ForegroundColor DarkYellow
}