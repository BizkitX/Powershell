$user = Read-Host "Enter users first, last, or full name"
$info = Get-ADUser -Filter "Name -like '*$user*'" -Properties * | 
Select-Object Name, @{Expression={$_.samaccountname};Label="User ID"}, Description, Enabled, LockedOut, Office, @{Expression={$_."msRTCSIP-Line"};Label="Lync Number"}, EmailAddress, PasswordLastSet, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

Write-Host -ForegroundColor Cyan "Searching for user information..."

if ($info -eq $null)
{Write-Warning "User not found"}
else
{
$info
}