param(
    [parameter(Mandatory)]
    [string]$ComputerName
)

$creds = Get-Credential -Message "Please enter your ADMIN credentials."
$Connection = Test-Connection $ComputerName -Count 1 -ErrorAction SilentlyContinue

If ($Connection -eq "$true")
{
PsExec.exe \\$ComputerName -s winrm.cmd quickconfig -q
Enter-PSSession -ComputerName $ComputerName -Credential $creds
}

Else
{
Write-Host -NoNewline -ForegroundColor Red "The computer is unreachable"
}