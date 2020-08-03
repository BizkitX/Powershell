$comp = Read-Host "Enter computername"
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $comp | where {$_.IPAddress} | fl Description, IPAddress