 function Get-LastBoot
 {
 $computer = Read-Host "Enter computername"
 $time = Get-WmiObject Win32_OperatingSystem -ComputerName $computer -Credential mottmac\adminwal63291
               
 [Management.ManagementDateTimeConverter]::ToDateTime($time.LastBootUpTime)  
 
 }