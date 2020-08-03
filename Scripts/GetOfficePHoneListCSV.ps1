$office = Read-Host "Enter office 3 letter prefix"
Get-ADUser -Filter {enabled -eq $True -and msRTCSIP-Line -like "tel*"} -SearchBase "OU=$office,OU=US,OU=North America,OU=NASA,OU=Mott MacDonald Group,DC=Mottmac,DC=group,DC=int" -Properties * |
Select-Object Name, msRTCSIP-Line |
Export-Csv -Verbose C:\Users\wal63291\Desktop/phonelist.csv