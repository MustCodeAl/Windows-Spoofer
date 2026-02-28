function Get-RandomHex {
    param ([int]$length = 8)
    return -join ((48..57 + 65..70) | Get-Random -Count $length | ForEach-Object { [char]$_ })
}

# GPU/PCI - Serial Number
# Spoof PCI device instance IDs (contains serial) for all PCI devices including GPU
# PNPDeviceID format: PCI\VEN_XXXX&DEV_XXXX&SUBSYS_XXXXXXXX&REV_XX\4&XXXXXXXX&0&XXXX
#                                                                         ^^^^^^^^ serial

Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Enum\PCI" -ErrorAction SilentlyContinue | ForEach-Object {
    Get-ChildItem $_.PSPath -ErrorAction SilentlyContinue | ForEach-Object {
        $instanceName = $_.PSChildName
        if ($instanceName -match '^([^&]+)&([0-9A-Fa-f]+)&([^&]+)&([^&]+)$') {
            $newSerial = Get-RandomHex -length 8
            $newInstanceName = "$($Matches[1])&$newSerial&$($Matches[3])&$($Matches[4])"
            Rename-Item -Path $_.PSPath -NewName $newInstanceName -Force -ErrorAction SilentlyContinue
        }
    }
}
