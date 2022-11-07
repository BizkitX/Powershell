$date = Get-Date -Format MM-dd
$LogFilePath = "C:\LOGS\DisabledUsers-$date.log"
$UsersOU = "OU=Users,OU=Archive,DC=ad,DC=dixieelectric,DC=coop"
$ComputersOU = "OU=Computers,OU=Archive,DC=ad,DC=dixieelectric,DC=coop"


Start-Transcript -Path $LogFilePath

Import-Module ActiveDirectory

#Searches for disabled USERS and moves them to the correct OU
Search-ADAccount -AccountDisabled -UsersOnly | 
Where-Object {$_.DistinguishedName -notmatch $UsersOU -and $_.Name -ne "Administrator"} |
Move-ADObject -TargetPath "$UsersOU" -Verbose

#Searches for disabled COMPUTERS and moves them to the correct OU
Search-ADAccount -AccountDisabled -ComputersOnly | 
Where-Object {$_.DistinguishedName -notmatch $ComputersOU} |
Move-ADObject -TargetPath "$ComputersOU" -Verbose

Stop-Transcript