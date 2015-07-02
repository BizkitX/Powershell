$comp = Read-Host "Enter computername"
gwmi -Class cim_videocontroller -ComputerName $comp | select name,driverversion
