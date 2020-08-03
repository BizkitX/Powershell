$ComputerName = Read-Host "Computer Name"
Get-WmiObject -Class Win32_Product -ComputerName $ComputerName -Filter "Name like 'Java%'" |
select Name, Version