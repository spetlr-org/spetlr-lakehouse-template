function Wait-DatabricksRun {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $runId,
  
        [Parameter(Mandatory = $false)]
        [int]
        $pollIntervalInSeconds = 5
    )
  
    $state = ""
    $state_message = ""
    $result_state = ""
    do {
        $json = databricks runs get --run-id $runId
        Throw-WhenError -output $json
        $run = $json | ConvertFrom-Json
  
        if ($state -ne $run.state.life_cycle_state) {
            $state = $run.state.life_cycle_state
            Write-Host "      Run state: $state" -ForegroundColor Cyan
        }
  
        if ($state_message -ne $run.state.state_message) {
            $state_message = $run.state.state_message
            Write-Host "      Run state message: $state_message" -ForegroundColor Cyan
        }
  
        Write-Host "      No new state found, waiting $pollIntervalInSeconds before polling again ..." -ForegroundColor DarkGray
        Start-Sleep -Seconds $pollIntervalInSeconds
        $result_state = $run.state.result_state
    } until ($result_state -or $state -eq "SKIPPED")
  
    if ($result_state -eq "FAILED") {
        Write-Host "      Run FAILED" -ForegroundColor Red
        throw
    }
  
    if ($state -eq "SKIPPED") {
        Write-Host "      Run SKIPPED" -ForegroundColor Red
        throw
    }
  
    Write-Host "      Run result: $result_state" -ForegroundColor Cyan
}
  