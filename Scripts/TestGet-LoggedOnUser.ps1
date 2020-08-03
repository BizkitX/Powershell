$ErrorActionPreference = "SilentlyContinue"
$comp = read-host "Please enter computer name"
$userID = (Get-WmiObject -Class win32_computersystem -ComputerName $comp).username.Split("\")[1]



if (Test-Connection $comp -quiet -Count 2)
{
 Write-Host -ForegroundColor Green "Computer $comp is online"
 Write-Host -ForegroundColor Cyan "Loading User Information..."
 Get-ADUser $userID -Properties * | select Name, Description, Office, TelephoneNumber | Format-List
 }
 Else{
 Write-Host -ForegroundColor Red "Computer $comp is offline"}

 
 