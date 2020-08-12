param(
[Parameter(Mandatory=$true)]
[string]
$ComputerName
)

$ErrorActionPreference = "SilentlyContinue"

$userID = (Get-WmiObject -Class win32_computersystem -ComputerName $ComputerName).username.Split("\")[1]



if (Test-Connection $ComputerName -quiet -Count 1)
{
 Write-Host -ForegroundColor Green "Computer $ComputerName is online"
 Write-Host -ForegroundColor Cyan "Loading User Information..."
 Get-ADUser $userID -Properties Name,Description,Office,TelephoneNumber | Select-Object Name, Description, Office, TelephoneNumber | Format-List
 }
 Else{
 Write-Host -ForegroundColor Red "Computer $ComputerName is offline"}

 Read-Host -Prompt "Press ENTER to quit"