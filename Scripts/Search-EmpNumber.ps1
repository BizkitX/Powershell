$emp = Read-Host "Enter Employee Number"
Get-ADUser -Filter "extensionAttribute3 -eq $emp" -Properties * | 
    select Name, Description, EmailAddress | Format-List
