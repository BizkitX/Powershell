$input = Read-Host "Enter Employee Number"
$userID = Get-ADUser -Filter {extensionAttribute3 -eq $input}
if ($userID -eq $null)
{Write-Warning "UserID not found in AD"}
Else
{
Move-ADObject -Identity $userID -TargetPath "ou=Disabled User Accounts,dc=hmmg,dc=cc" -PassThru -Verbose -Confirm |
Disable-ADAccount -Verbose -Confirm
}