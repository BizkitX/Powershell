set-location c:\
$console = $(get-host).UI.RawUI

$console.WindowTitle = "Brian's PowerShell"
$console.BackgroundColor = "Black"
$console.ForegroundColor = "White"
Set-ItemProperty -Path HKCU:\Console -Name WindowsAlpha -Value 205
Import-Module "C:\Users\wal63291\Documents\WindowsPowerShell\Powershell\Modules\MyPowershellModule\MyPowershellModule.psm1"
Import-Module ActiveDirectory
Clear-Host
Write-Host "Welcome back Brian"
Write-Host "Today is" (get-date)
write-host ""

