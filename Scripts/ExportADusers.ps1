$OU = Read-Host "Enter the 3 letter office OU"
Get-ADUser -SearchBase "ou=users,ou=$OU,ou=us,dc=hmmg,dc=cc" -Properties * -Filter * | select Name, SamAccountName, Description, OfficePhone, ScriptPath |Export-Csv -NoTypeInformation "C:\Users\wal63291\Desktop\ADUserExport.csv"
