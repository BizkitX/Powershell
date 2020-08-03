$computer = Read-Host "Enter Computername"
Invoke-WmiMethod -Class CCM_ClientUtilities `
    -Namespace ROOT\ccm\ClientSDK -Name DetermineIfRebootPending -ComputerName $computer `
    | select RebootPending, IsHardRebootPending
