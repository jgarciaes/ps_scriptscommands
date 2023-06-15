# Get the current date
$currentTime = Get-Date

# Set the start time to today at 1 AM
$startTime = (Get-Date -Year $currentTime.Year -Month $currentTime.Month -Day $currentTime.Day -Hour 2 -Minute 0 -Second 0).AddDays(0)

# Set the end time to today at 5 AM
$endTime = (Get-Date -Year $currentTime.Year -Month $currentTime.Month -Day $currentTime.Day -Hour 4 -Minute 0 -Second 0).AddDays(0)

# Function to display event details
function ShowEventDetails($event) {
    Write-Host "Source: $($event.ProviderName)"
    Write-Host "Event ID: $($event.Id)"
    Write-Host "Level: $($event.LevelDisplayName)"
    Write-Host "Message: $($event.Message)"
    Write-Host "Timestamp: $($event.TimeCreated)"
    Write-Host "-----"
}

# Get error and warning events from System log
$systemEvents = Get-WinEvent -FilterHashtable @{
    LogName   = 'System'
    Level     = 2, 3  # 2 - Error, 3 - Warning
    StartTime = $startTime
    EndTime   = $endTime
}

# Display System events
if ($systemEvents) {
    Write-Host "System Error and Warning Events:"
    foreach ($event in $systemEvents) {
        ShowEventDetails $event
    }
} else {
    Write-Host "No System error or warning events found between 1 AM and 5 AM today."
}

# Get error and warning events from Application log
$applicationEvents = Get-WinEvent -FilterHashtable @{
    LogName   = 'Application'
    Level     = 2, 3  # 2 - Error, 3 - Warning
    StartTime = $startTime
    EndTime   = $endTime
}

# Display Application events
if ($applicationEvents) {
    Write-Host "Application Error and Warning Events:"
    foreach ($event in $applicationEvents) {
        ShowEventDetails $event
    }
} else {
    Write-Host "No Application error or warning events found between 1 AM and 5 AM today."
}

# Get error and warning events from Custom Views log
$customViewsEvents = Get-WinEvent -FilterHashtable @{
    LogName   = 'Custom Views'
    Level     = 2, 3  # 2 - Error, 3 - Warning
    StartTime = $startTime
    EndTime   = $endTime
}

# Display Custom Views events
if ($customViewsEvents) {
    Write-Host "Custom Views Error and Warning Events:"
    foreach ($event in $customViewsEvents) {
        ShowEventDetails $event
    }
} else {
    Write-Host "No Custom Views error or warning events found between 1 AM and 5 AM today."
}
