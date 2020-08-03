$comp = Read-Host "Enter computername"
([WMI]'').ConvertToDateTime((Get-WmiObject Win32_OperatingSystem -ComputerName $comp).InstallDate)