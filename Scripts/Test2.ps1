# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Get the current date
$CurrentDate = Get-Date

# Get the default password policy for the domain
$PasswordPolicy = Get-ADDefaultDomainPasswordPolicy

# Get all AD users whose passwords have not expired
$ExpiringUsers = Get-ADUser -Filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordExpired -eq $False -and SamAccountName -ne 'varonisadmin' -and SamAccountName -ne 'bobbyd'} -Properties Name, SamAccountName, PasswordLastSet

# Filter the results to only include users whose passwords are going to expire within the next 5 days
$ExpiringUsers = $ExpiringUsers | Where-Object {(($CurrentDate - $_.PasswordLastSet).TotalDays) -ge (($PasswordPolicy.MaxPasswordAge).TotalDays - 30)}

# Display the results
$ExpiringUsers = $ExpiringUsers | Select-Object Name, SamAccountName, PasswordLastSet, @{Name="ExpirationDate"; Expression={$_.PasswordLastSet.AddDays($PasswordPolicy.MaxPasswordAge.TotalDays)}} -ExpandProperty ExpirationDate |
Sort-Object ExpirationDate |
Format-Table

foreach ($User in $ExpiringUsers) {
        Write-Output "Hello $($User.Name), Please consider changing your password as it is due to expire on $($User.ExpirationDate)"
}





