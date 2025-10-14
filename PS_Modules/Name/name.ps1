$RandomString = -join ([char[]](48..57 + 65..90) | Get-Random -Count 7)

# Local Windows User Account
# $env:USERNAME
# Rename-LocalUser -Name "$env:USERNAME" -NewName "$RandomString$RandomString"

# Local Computer Name (Device Name)
# [System.Environment]::MachineName
Rename-Computer -NewName "DESKTOP-$RandomString" -Force *>$null
# Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName' -Name 'ComputerName' -Type String -Value "DESKTOP-$RandomString" -Force

# Network Computer Name (NetBIOS Name)
# [System.Net.Dns]::GetHostName()
# Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName' -Name 'ComputerName' -Type String -Value "DESKTOP-$RandomString" -Force
