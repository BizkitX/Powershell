$comp = read-host "Please enter computer name"
$userID = (Get-WmiObject -Class win32_computersystem -ComputerName $comp | select username | ft -hide | Out-String)
$final = $userId.TrimStart().Trim("HMMG\").TrimEnd()

if (Test-Connection $comp -quiet -Count 2)
{
 Write-Host -ForegroundColor Green "Computer $comp is online"
 }
 Else{
 Write-Host -ForegroundColor Red "Computer $comp is offline"}

 Get-ADUser $final -Properties * | select Name, Description, Office, telephoneNumber
 
