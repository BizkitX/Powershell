$last = Read-Host "Enter the users last name"
$info = Get-ADComputer -Filter " Description -like '*$last*' " -Properties Name, Description | 
Select-Object Name, Description |
Format-Table -AutoSize

Write-Host -ForegroundColor Cyan "Searching for computer..."

if ($info -eq $null)
{Write-Warning "User's last name not found"}
else
{$info}
