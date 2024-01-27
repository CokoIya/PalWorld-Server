
# Paths and intervals configuration
$palworldPath = "C:\Users\Administrator\Desktop\steamcmd\steamapps\common\PalServer"
$backupPath = "C:\Users\Administrator\Desktop\steamcmd\steamapps\common\backup"
$backupInterval = New-TimeSpan -Hours 0.5
$checkInterval = New-TimeSpan -Seconds 30
$maxBackups = 5  # Maximum number of backup folders to keep

function Start-PalServer {
    Write-Host "Starting PalServer.exe...2831816385"
    Start-Process -FilePath "$palworldPath\PalServer.exe" -WindowStyle Hidden
}

function Perform-Backup {
    $backupFolderName = (Get-Date).ToString("yyyy-MM-dd_HH-mm-ss")
    $backupFolderPath = Join-Path $backupPath "Backup_$backupFolderName"
    Copy-Item -Path "$palworldPath\Pal\Saved" -Destination $backupFolderPath -Recurse
    Write-Host "Backup completed at $(Get-Date)"

    # Remove old backups, keep only the latest $maxBackups
    $backupFolders = Get-ChildItem -Path $backupPath -Directory | Sort-Object CreationTime -Descending
    if ($backupFolders.Count -gt $maxBackups) {
        $backupFolders | Select-Object -Skip $maxBackups | Remove-Item -Recurse -Force
        Write-Host "Old backups removed, only the latest $maxBackups backups are kept."
    }
}

# Main loop
$lastBackupTime = Get-Date
while ($true) {
    # Check if PalServer is running
    $process = Get-Process PalServer-Win64-Test-Cmd -ErrorAction SilentlyContinue
    if (-not $process) {
        Write-Host "PalServer.exe is not running. Attempting to start..."
        Start-PalServer
    }

    # Perform backup if it's time
    $currentTime = Get-Date
    if ($currentTime - $lastBackupTime -ge $backupInterval) {
        Perform-Backup
        $lastBackupTime = Get-Date
    }

    # Wait for the next check
    Start-Sleep -Seconds $checkInterval.TotalSeconds
}
