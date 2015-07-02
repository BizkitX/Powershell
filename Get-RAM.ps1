$name = Read-Host "Enter computername"
gwmi -class Win32_PhysicalMemory -ComputerName $name | 
Measure-Object -Property capacity -Sum | 
select @{N="Total Physical Ram"; E={[math]::round(($_.Sum / 1GB),2)}} |
Format-Table -AutoSize
