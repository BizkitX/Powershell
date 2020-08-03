$comp = Read-Host "Enter Computername"
Get-WmiObject –Class Win32_Volume -ComputerName $comp -Credential mottmac\adminwal63291 | Format-Table –auto DriveLetter,`
                  Label,`
                  @{Label=”Free(GB)”;Expression={“{0:N0}” –F ($_.FreeSpace/1GB)}},`
                  @{Label=”%Free”;Expression={“{0:P0}” –F ($_.FreeSpace/$_.Capacity)}}