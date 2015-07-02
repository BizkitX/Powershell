$comp = Read-Host "Enter computername"
gwmi -Class win32_mappedlogicaldisk -ComputerName $comp | 
select Name, ProviderName |
Format-Table -AutoSize
