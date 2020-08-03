$ComputerName = read-host "Enter Computer Name to test"
 
if (Test-Connection $ComputerName -quiet -Count 2)
{
 Write-Host -ForegroundColor Green "Computer $ComputerName is online"
 }
 Else{
 Write-Host -ForegroundColor Red "Computer $ComputerName is offline"}
