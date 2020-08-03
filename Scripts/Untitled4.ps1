$user = Read-Host "Enter username"

Get-ADUser $user –Properties "DisplayName", "PasswordLastSet", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property Displayname, PasswordLastSet, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}