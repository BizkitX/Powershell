$comp = Read-Host "Enter computername"
$objComputer = Get-ADComputer $comp
get-adobject -Filter * | Where-Object {$_.DistinguishedName -match $objComputer.Name -and $_.ObjectClass -eq "msFVE-RecoveryInformation"}
