param(
    [parameter(Mandatory)]
    [string]$ComputerName
)

$Connection = Test-Connection $ComputerName -Count 1 -Quiet

If ($Connection -eq "True")
{
PsExec.exe \\$ComputerName -s winrm.cmd quickconfig -q
}

Else
{
Write-Host -ForegroundColor Red "The computer is unreachable"
}