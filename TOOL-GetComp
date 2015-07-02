$last = Read-Host "Enter the users last name"
Get-ADComputer -Filter " Description -like '*$last*' " -Properties * | 
select Name, Description |
Format-Table -AutoSize
