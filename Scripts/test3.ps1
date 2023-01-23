$OUs = "OU=Servers,DC=ad,DC=dixieelectric,DC=coop", "OU=Domain Controllers,DC=ad,DC=dixieelectric,DC=coop"

$OUs | foreach {
    Get-ADComputer -Filter * -SearchBase $_ -Properties Name, OperatingSystem} | 
    Select-Object Name, OperatingSystem |
    Export-Csv C:\TEMP\ServerList.csv
    
  
