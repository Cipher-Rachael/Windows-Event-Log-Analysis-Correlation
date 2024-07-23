# Define the log name (replace with the specific log you want, e.g., Application)
$LogName = "System"

# Get the Desktop path
$DesktopPath = [Environment]::GetFolderPath("Desktop")

# Define the start and end dates for the filter
$StartDate = [datetime]"2024-06-23"
$EndDate = [datetime]"2024-07-20"

# Get all events from the specified log and filter by date range
$Events = Get-EventLog -LogName $LogName | Where-Object { $_.TimeGenerated -ge $StartDate -and $_.TimeGenerated -le $EndDate }

if ($Events.Count -eq 0) {
    Write-Host "No events found in the $LogName log between $StartDate and $EndDate."
    exit
}

# Select desired properties from each event
$EventData = $Events | Select-Object TimeGenerated, Level, Source, EventID, Message

# Create the CSV file path with a timestamp
$CsvFilePath = Join-Path $DesktopPath -ChildPath ("EventLog_$($LogName)_" + (Get-Date -Format yyyyMMddHHmm) + ".csv")

# Export events data to CSV file
$EventData | Export-Csv -Path $CsvFilePath -NoTypeInformation

# Informative message
Write-Host "Successfully saved events from the $LogName log between $StartDate and $EndDate to: $CsvFilePath"
