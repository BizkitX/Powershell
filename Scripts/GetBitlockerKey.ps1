$input= Read-Host "Enter computername"
$computer= Get-ADComputer -Filter {cn -eq $input}
if ($computer -eq $null)
{Write-Warning "Failed...Computer not found in AD"}
Else
{
Get-ADObject -Filter {objectclass -eq 'msFVE-RecoveryInformation'} -SearchBase $computer.DistinguishedName -Properties 'msFVE-RecoveryPassword' | 
Select-Object @{Expression={$_.'msFVE-RecoveryPassword'};Label="Bitlocker Recovery Key"} |
Out-File -Verbose C:\Users\wal63291\Desktop\RecoveryKeys\$input.txt
}
