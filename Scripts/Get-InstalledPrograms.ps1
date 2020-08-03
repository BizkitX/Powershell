﻿$comp = Read-Host "Please enter computername"
Get-WmiObject -Class win32reg_addremoveprograms -ComputerName $comp | Select-Object DisplayName, Version, InstallDate | Sort-Object DisplayName | Out-GridView