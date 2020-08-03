$office = Read-Host "Enter office 3 letter prefix"
Get-ADUser -Filter {enabled -eq $True -and msRTCSIP-Line -like "tel*"} -SearchBase "OU=$office,OU=US,OU=North America,OU=NASA,OU=Mott MacDonald Group,DC=Mottmac,DC=group,DC=int" -Properties * |
Select-Object Name, msRTCSIP-Line, Mobile |
Sort-Object Name | Out-GridView |
Format-Table -AutoSize Name, @{Expression={$_.'msRTCSIP-Line'};Label="Lync Number"}