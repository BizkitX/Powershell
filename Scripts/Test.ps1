# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Get the current date
$CurrentDate = Get-Date

# Get all AD users whose passwords have not expired
$ExpiringUsers = Get-ADUser -Filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordExpired -eq $False} -Properties Name, SamAccountName, PasswordLastSet

# Filter the results to only include users whose passwords are going to expire within the next 5 days
$ExpiringUsers = $ExpiringUsers | Where-Object {(($CurrentDate - $_.PasswordLastSet).TotalDays) -ge (365 - 5)}

# Display the results
$ExpiringUsers | Select-Object Name, SamAccountName, PasswordLastSet, @{Name="ExpirationDate"; Expression={$_.PasswordLastSet.AddDays(365)}} |
Sort-Object ExpirationDate |
Format-Table

foreach ($User in $ExpiringUsers){
    $Name = $User.Name
    $ExpirationDate = $User.ExpirationDate
    Write-Output "Hello $Name, Please consider changing your password as it is due to expire on $ExpirationDate"
}