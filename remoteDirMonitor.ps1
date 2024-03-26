Write-Host "Monitoring Remote machine....."


while ($true) {
    $output = & rsync-win -ar --progress -i gcp-vms1 --src cheatedepk@35.202.173.202:/home/cheatedepk/projects/tempFolder/ --dest "C:\Users\Docker\Desktop\monitoreFolder\" 2>&1

    # save output to log file
    $output | Out-File -FilePath "C:\Users\Docker\Desktop\vitalScripts\remoteDirMonitor.log" -Append

    Start-Sleep -Seconds 1
}
