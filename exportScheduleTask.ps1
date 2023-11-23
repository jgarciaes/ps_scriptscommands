

# Specify the path where you want to export Task Scheduler tasks
$exportPath = ""

# Create the export directory if it doesn't exist
if (-not (Test-Path -Path $exportPath -PathType Container)) {
    New-Item -Path $exportPath -ItemType Directory | Out-Null
}

# Get tasks from Task Scheduler Library
$tasks = Get-ScheduledTask | Where-Object { $_.TaskPath -eq "\" }

# Export each task to a separate XML file
foreach ($task in $tasks) {
    $taskName = $task.TaskName
    $exportFilePath = Join-Path -Path $exportPath -ChildPath "$taskName.xml"
    Export-ScheduledTask -TaskName $taskName | Export-Clixml -Path $exportFilePath
    Write-Host "Task '$taskName' exported to $exportFilePath"
}
