function Get-TestJob {
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $TestJobDetails = "test_job_details.json"
    )

    $srcDir = "$PSScriptRoot/../../../"

    $testJobDetailsPath = "$PSScriptRoot/$TestJobDetails"

    # import utility functions
    . "$srcDir\deploy\utilities\Wait-DatabricksRun.ps1"

    # check if test_job_details file can be loaded
    if (-not (Test-Path -Path $testJobDetailsPath -PathType Leaf)) {
        Write-Host "ERROR: The file $testJobDetailsPath does not exist. Please run submit_test_job.ps1 first." -ForegroundColor Red
        exit 1
    }

    $job_details = Get-Content $testJobDetailsPath | ConvertFrom-Json

    $runId = $job_details.runId
    $databricksTestDir = $job_details.databricksTestDir
    $resultLogs = $job_details.logOut
    $srcDir = $PSScriptRoot

    # report on status
    Write-Host "  Get run with ID $runId" -ForegroundColor DarkYellow
    Write-Host "  And test dir $databricksTestDir" -ForegroundColor DarkYellow

    $runFailed = $false

    try {
        Wait-DatabricksRun `
            -runId $runId
    }
    catch {
        $runFailed = $True
    }

    Write-Host "  Run has ended. Now fetching logs..." -ForegroundColor DarkYellow
    $localLogs = "$srcDir/test_job_results_$($job_details.submissionTime).log"

    # If local log not exists download from databricks
    if (-not(Test-Path -Path $localLogs -PathType Leaf)) {
        $timeout = 60
        do {
            dbfs cp --overwrite $resultLogs $localLogs

            if ($LASTEXITCODE -eq 0) {
                break;
            }

            $timeout -= 1
            Start-Sleep -Seconds 1
        } until($timeout -lt 1)

        if ($timeout -lt 1) {
            throw "Unable to get logs from $resultLogs"
        }

        dbfs rm $databricksTestDir -r
    }

    Write-Host "  Logs can be seen in $localLogs" -ForegroundColor DarkYellow

    Get-Content $localLogs

    if ($runFailed) {
        exit 1
    }
    else {
        exit 0
    }
}