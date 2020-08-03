$comp = Read-Host "Enter computer name"
Get-ADComputer $comp -Properties * | select description