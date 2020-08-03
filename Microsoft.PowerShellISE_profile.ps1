set-location c:\
$console = $(get-host).UI.RawUI

$console.WindowTitle = "Brian's PowerShell"
$console.BackgroundColor = "Black"
$console.ForegroundColor = "White"
Import-Module C:\Users\wal63291\Documents\WindowsPowerShell\Modules\MyPowershellModule\MyPowershellModule.psm1
Import-Module ActiveDirectory
Import-Module C:\Users\wal63291\Documents\WindowsPowerShell\Modules\MyPowershellModule\SCCM.psm1
Clear-Host

Write-Host "Welcome back Brian"
Write-Host "Today is" (get-date)
write-host ""

