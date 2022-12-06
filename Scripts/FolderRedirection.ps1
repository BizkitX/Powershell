#Finds all user accounts that are not a member of the 'Folder Redirection Users' group in AD and exports the list to a CSV file.

Get-ADUser -Filter * -Properties Name, MemberOf, Description |
Where-Object {$_.MemberOf -notcontains "CN=Folder Redirection Users,CN=Users,DC=ad,DC=dixieelectric,DC=coop" -and $_.Enabled -eq $True} |
Select-Object Name, Enabled, Description, MemberOf |
Sort-Object Name |
Export-Csv C:\TEMP\FolderRedirection.csv 


