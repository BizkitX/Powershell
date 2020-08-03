$users = Get-Content C:\userlist.txt 
ForEach ($user in $users)
{
Set-ADAccountPassword $user -NewPassword (ConvertTo-SecureString -AsPlainText "Hatchmott123!" -Force) -Reset
}