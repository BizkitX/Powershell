param(
    [parameter(Mandatory)]
    [string]$ComputerName
)

$creds = Get-Credential -Message "Please enter your ADMIN credentials."
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