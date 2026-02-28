function Get-UpperRandomString {
    return -join ((48..57 + 65..90) | Get-Random -Count 20 | ForEach-Object { [char]$_ })
}

# RAM/Memory Device - Serial Number
# Uses AMI BIOS DMI Editor (AMIDEWINx64.EXE) to spoof SMBIOS Type 17 memory serial numbers

$toolPath = "$env:TEMP\AMIDEWINx64.EXE"
$driverPath = "$env:TEMP\amifldrv64.sys"

if (-not (Test-Path $toolPath)) {
    $zipPath = "$env:TEMP\dmi-edit-win64-ami.zip"
    try {
        Invoke-WebRequest -Uri "https://download.schenker-tech.de/package/dmi-edit-efi-ami/?wpdmdl=3997&ind=1647077068432&filename=dmi-edit-win64-ami.zip" -OutFile $zipPath -UseBasicParsing
        Expand-Archive -Path $zipPath -DestinationPath $env:TEMP -Force
        Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
    } catch {
        Write-Host "Failed to download AMI BIOS DMI Editor"
        exit 1
    }
}

# Spoof serial number for each installed RAM module
$memoryModules = Get-CimInstance -ClassName Win32_PhysicalMemory -ErrorAction SilentlyContinue
foreach ($module in $memoryModules) {
    if ($module.SerialNumber -and $module.SerialNumber -notin @("Unknown", "To Be Filled By O.E.M.", "")) {
        $newSerial = Get-UpperRandomString
        Start-Process -FilePath $toolPath -ArgumentList "/MSN", "`"$newSerial`"" -NoNewWindow -Wait -ErrorAction SilentlyContinue
    }
}

# Cleanup
Remove-Item $toolPath -Force -ErrorAction SilentlyContinue
Remove-Item $driverPath -Force -ErrorAction SilentlyContinue
