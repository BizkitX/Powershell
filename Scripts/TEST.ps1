Get-ADUser -Filter {Enabled -eq "False"} -Properties Name |
Where-Object {$_.DistinguishedName -notmatch "OU=Users,OU=Archive,DC=ad,DC=dixieelectric,DC=coop"} |
Select-Object Name |
Sort-Object Name