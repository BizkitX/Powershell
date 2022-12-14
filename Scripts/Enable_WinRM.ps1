param(
    [parameter(Mandatory)]
    [string]$ComputerName
)

$Connection = Test-Connection $ComputerName -Count 1 -ErrorAction SilentlyContinue

If ($Connection -eq "$true")
{
PsExec.exe \\$ComputerName -s winrm.cmd quickconfig -q
}

Else
{
Write-Host -NoNewline -ForegroundColor Red "The computer is unreachable"
}