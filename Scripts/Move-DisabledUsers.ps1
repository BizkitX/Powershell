$LogFilePath = "C:\TEMP\DisabledUsers.log"

Start-Transcript -Path $LogFilePath

Import-Module ActiveDirectory

Search-ADAccount -AccountDisabled -UsersOnly | Move-ADObject -TargetPath "OU=Disabled Users,DC=ad,DC=dixieelectric,DC=coop"

Stop-Transcript