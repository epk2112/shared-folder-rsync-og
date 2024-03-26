
# Define the source path to watch
$sourcePath = "C:\Users\Docker\Desktop\monitoreFolder\"


# Create a new file system watcher
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $sourcePath
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

# Event handler for file changes
$actionScript = {
    $path = $Event.SourceEventArgs.FullPath
    $changeType = $Event.SourceEventArgs.ChangeType
    Write-Host "File $changeType : $path" -ForegroundColor Green

    # Run rsync-win command
    $output = & rsync-win -ar --progress  --src "C:\Users\Docker\Desktop\monitoreFolder\" --dest "C:\Users\Docker\Desktop\destFolder\" 2>&1
    Write-Host $output
}

# Register the event handler for file changes
Register-ObjectEvent -InputObject $watcher -EventName "Created" -Action $actionScript
Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $actionScript
Register-ObjectEvent -InputObject $watcher -EventName "Deleted" -Action $actionScript
Register-ObjectEvent -InputObject $watcher -EventName "Renamed" -Action $actionScript

# Display monitoring info
Write-Host "Monitoring directory: $($watcher.Path)"
Write-Host "Press 'CTRL+C' to stop monitoring."

# Wait for events
try {
    while ($true) {
        Start-Sleep -Seconds 1
    }
}
finally {
    $watcher.Dispose()
}