$input = Read-Host "Enter computer name"
$comp = Get-ADComputer -filter {cn -eq $input}
If ($comp -eq $null){Write-Warning "Computer not found in AD"}
Else
{
$desc = Read-Host "Enter description"
Set-ADComputer $comp -Description $desc -Credential mottmac\adminwal63291
Write-Host -ForegroundColor Green "Complete"
}