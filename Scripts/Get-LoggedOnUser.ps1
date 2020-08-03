$ErrorActionPreference = "SilentlyContinue"
$comp = read-host "Please enter computer name"
$userID = (Get-WmiObject -Class win32_computersystem -ComputerName $comp).username.Split("\")[1]



if (Test-Connection $comp -quiet -Count 1)
{
 Write-Host -ForegroundColor Green "Computer $comp is online"
 Write-Host -ForegroundColor Cyan "Loading User Information..."
 Get-ADUser $userID -Properties Name,Description,Office,TelephoneNumber | Select-Object Name, Description, Office, TelephoneNumber | Format-List
 }
 Else{
 Write-Host -ForegroundColor Red "Computer $comp is offline"}

 Read-Host -Prompt "Press ENTER to quit"

 
 