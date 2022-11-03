param(
    [Parameter(Mandatory = $True)]
    [string]
    $SamAccountName
)

Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'" -Properties "DisplayName", "PasswordExpired", "PasswordLastSet", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property Displayname, PasswordLastSet, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} |
Format-List

$PasswordExpired = (Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'" -Properties "PasswordExpired").PasswordExpired
If ($PasswordExpired -eq "True")
{ 
    Write-Host "Password is Expired!" -ForegroundColor Red
}
else {
    Write-Host "Password is still good." -ForegroundColor Green
}