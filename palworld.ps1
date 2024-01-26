# 设置路径和间隔
$palworldPath = "C:\Users\Administrator\Desktop\steamcmd\steamapps\common\PalServer"
$backupPath = "C:\Users\Administrator\Desktop\steamcmd\steamapps\common\backup"
$backupInterval = New-TimeSpan -Hours 3
$checkInterval = New-TimeSpan -Seconds 15

# 初始化上次备份时间
$lastBackupTime = Get-Date

while ($true) {
    # 检查 PalServer.exe 是否在运行
    $process = Get-Process PalServer-Win64-Test-Cmd -ErrorAction SilentlyContinue
    if (-not $process) {
        Write-Host "PalServer.exe is not running. Starting...2831816385"
        Start-Process -FilePath "$palworldPath\PalServer.exe" -WindowStyle Hidden
    }

    # 检查是否需要执行备份
    $currentTime = Get-Date
    if ($currentTime - $lastBackupTime -ge $backupInterval) {
        Write-Host "Performing backup...2831816385"
        $backupFolderName = $currentTime.ToString("yyyy-MM-dd_HH-mm-ss")
        $backupFolderPath = Join-Path $backupPath "Backup_$backupFolderName"
        Copy-Item -Path "$palworldPath\Pal\Saved" -Destination $backupFolderPath -Recurse
        Write-Host "Backup completed!"
        $lastBackupTime = Get-Date
    }

    # 等待一段时间
    Start-Sleep -Seconds $checkInterval.TotalSeconds
}
