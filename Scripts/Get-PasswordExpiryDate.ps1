param(
    [Parameter(Mandatory)]
    [string]
    $UserName
)

Get-ADUser $UserName –Properties "DisplayName", "PasswordLastSet", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property Displayname, PasswordLastSet, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} |
Format-List