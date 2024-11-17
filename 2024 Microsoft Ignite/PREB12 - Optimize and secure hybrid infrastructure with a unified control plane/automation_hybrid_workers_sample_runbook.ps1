<#
Runbook: Invoke-DiskCleanup
Automation: twt-aa
RG: tailwindtraders-automation-rg
#>

if ($IsWindows) {

    Write-Output 'Free disk space before cleanup action'
    Get-Volume -DriveLetter C | Out-String

    Write-Output "Windows Update component store cleanup"
    Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

    $SystemTemp = "$env:SystemRoot\Temp"
    Write-Output "Empty the system temporary folder: $SystemTemp"
    
    Get-ChildItem -Path $SystemTemp -Recurse | Remove-Item -Force -Recurse

    Write-Output 'Free disk space after cleanup action'
    Get-Volume -DriveLetter C | Out-String

} elseif ($IsLinux) {

    Write-Output 'Free disk space before cleanup action'
    df -h -m

    # Specify the directory where your log files are located
    $logDir = '/var/log'

    # Define the number of days to retain log files
    $daysToKeep = 7

    # Get the current date
    $currentDate = Get-Date

    # Calculate the date threshold for log file deletion
    $thresholdDate = $currentDate.AddDays(-$daysToKeep)

    # List log files in the specified directory that are older than the threshold
    $filesToDelete = Get-ChildItem -Path $logDir -File | Where-Object { $_.LastWriteTime -lt $thresholdDate }

    # Delete the old log files
    foreach ($file in $filesToDelete) {
        Remove-Item -Path $file.FullName -Force
    }

    Write-Output 'Free disk space after cleanup action'
    df -h -m

}
