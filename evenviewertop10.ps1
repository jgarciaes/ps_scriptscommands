# Define your variables
$Date = $null                  # Set this to the desired date in YYYY-MM-DD format (optional)
$Time = $null                  # Set this to the desired time in HH:MM:SS format (optional)
$Keyword = $null               # Set a keyword to search in the log message (optional)
$LevelDisplayNameId = "" # Numeric level ID to filter by (optional, default is all)
$Limit = 10                    # Set the number of top results to display

# Set default to today's date if $Date is not specified
if (-not $Date) {
    $Date = (Get-Date).ToString("yyyy-MM-dd")
}

# Combine Date and Time if both are provided, or use start of day if only the date is provided
if ($Date -and $Time) {
    $DateTime = Get-Date "$Date $Time"
} elseif ($Date) {
    $DateTime = Get-Date "$Date 00:00:00"
} else {
    $DateTime = $null # No date filter if both are not specified (although today's date will be used by default here)
}

# Fetch logs from Event Viewer
$Logs = Get-WinEvent -LogName "Application" -MaxEvents 1000 |  # Fetch up to 1000 recent logs
    Where-Object {
        # Filter by Date and Time if specified
        ($DateTime -eq $null -or $_.TimeCreated -ge $DateTime) -and 
        # Filter by Level if specified (using Level instead of Id)
        ($LevelDisplayNameId -eq $null -or $_.Level -eq $LevelDisplayNameId) -and
        # Filter by Keyword if specified (only if Keyword is not null or empty)
        ($Keyword -eq $null -or $_.Message -match $Keyword)
    } | 
     Select-Object TimeCreated, Id, LevelDisplayName, Message -First $Limit

# Display the filtered logs
$Logs | Format-Table -AutoSize
