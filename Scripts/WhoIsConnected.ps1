Get-WmiObject -Class Win32_ServerConnection | 
Select-Object -Property ComputerName, ConnectionID, UserName, ShareName