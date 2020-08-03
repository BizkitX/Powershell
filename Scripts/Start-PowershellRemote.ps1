$creds = Get-Credential -Message "Please enter your ADMINISTRATOR credentials."
$ComputerName = Read-Host "Enter Computer Name"
$Connection = Test-Connection $ComputerName -Count 1 -Quiet

If ($Connection -eq "True")
{
PsExec.exe \\$ComputerName -s winrm.cmd quickconfig -q
Enter-PSSession -ComputerName $ComputerName -Credential $creds
}

Else
{
Write-Host -ForegroundColor Red "The computer is unreachable"
}