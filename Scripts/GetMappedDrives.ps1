$comp = Read-Host "Enter computername"
$info = gwmi -Class win32_mappedlogicaldisk -ComputerName $comp | 
select Name, ProviderName |
Format-Table -AutoSize

if ($info -eq $null)
{Write-Warning "Computer is either offline or not found in AD"}
else
{$info}