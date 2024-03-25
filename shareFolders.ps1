$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = "C:\Users\Docker\Desktop\monitoreFolder"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$created = Register-ObjectEvent $watcher "Created" -SourceIdentifier FileCreated -Action {
    $fileInfo = $Event.SourceEventArgs.FullPath

    # Run a powershell command and capture its output
    $output = Invoke-Expression -Command "C:\rsync-win\rsync-win.exe -r --progress --src '/cygdrive/c/Users/Docker/Downloads/Downloads_server/' --dest '/cygdrive/c/Users/Docker/Desktop/bongoDir/'" 2>&1 | Out-String

    # Display the output
    Write-Host $output
    
    Write-Host "File created: $fileInfo" -ForegroundColor Green
}

$changed = Register-ObjectEvent $watcher "Changed" -SourceIdentifier FileChanged -Action {
    $fileInfo = $Event.SourceEventArgs.FullPath
    Write-Host "File changed: $fileInfo" -ForegroundColor Yellow
}

$deleted = Register-ObjectEvent $watcher "Deleted" -SourceIdentifier FileDeleted -Action {
    $fileInfo = $Event.SourceEventArgs.FullPath
    Write-Host "File deleted: $fileInfo" -ForegroundColor Red
}

$renamed = Register-ObjectEvent $watcher "Renamed" -SourceIdentifier FileRenamed -Action {
    $fileInfo = $Event.SourceEventArgs.FullPath
    Write-Host "File renamed: $fileInfo" -ForegroundColor Cyan
}

Write-Host "Monitoring directory: $($watcher.Path)"
Write-Host "Press 'CTRL+C' to stop monitoring."

try {
    while ($true) {
        Start-Sleep -Milliseconds 100
    }
}
finally {
    Unregister-Event $created.Id
    Unregister-Event $changed.Id
    Unregister-Event $deleted.Id
    Unregister-Event $renamed.Id
    $watcher.Dispose()
}