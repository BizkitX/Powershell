param(
    [Parameter(Mandatory = $True)]
    [string]
    $Name
)

Get-ADUser -Filter "DisplayName -like '*$Name*'" –Properties "DisplayName", "PasswordExpired", "PasswordLastSet", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property Displayname, PasswordExpired, PasswordLastSet, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} |
Format-List