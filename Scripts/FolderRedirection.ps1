# Find all enabled user accounts that are not members of the 'Folder Redirection Users' group and have been logged in within the past 14 days
$users = Get-ADUser -Filter {Enabled -eq $True} -Properties Name, MemberOf, Description, LastLogonDate |
  Where-Object {$_.MemberOf -notcontains "CN=Folder Redirection Users,CN=Users,DC=ad,DC=dixieelectric,DC=coop" -and $_.LastLogonDate -ge (Get-Date).AddDays(-14)}

# Sort the users by name and export the list to a CSV file
$users |
  Select-Object Name, Enabled, Description, MemberOf, LastLogonDate |
  Sort-Object Name |
  Export-Csv C:\TEMP\FolderRedirection.csv


