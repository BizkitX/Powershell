$user = Read-Host "Enter user's first and last name"
Get-ADUser -Filter {Name -eq $user} -Properties * | 
select Name, @{Expression={$_.samaccountname};Label="User ID"}, Description, Office, TelephoneNumber, EmailAddress
