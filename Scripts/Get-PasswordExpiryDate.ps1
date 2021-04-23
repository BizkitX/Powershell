param(
    [Parameter(Mandatory)]
    [string]
    $Name
)

Get-ADUser -Filter "DisplayName -like '*$Name*'" –Properties "DisplayName", "PasswordLastSet", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property Displayname, PasswordLastSet, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} |
Format-List