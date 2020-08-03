$ComputerName = Read-Host "Enter Computer Name"

$Connection = Test-Connection -ComputerName $ComputerName -Count 1 -Quiet

If($Connection -eq "True")
{
PsExec.exe \\$ComputerName -s winrm.cmd quickconfig -q
Get-CimInstance -ClassName ccm_application -Namespace "root\ccm\clientsdk" -ComputerName $ComputerName | select Name, InstallState, PercentComplete | Sort-Object Name | Out-GridView
}

Else
{
Write-Host -ForegroundColor Red "Computer is unreachable"
}