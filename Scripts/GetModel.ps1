$input = read-host "Enter the computer name"
$comp = Get-ADComputer -Filter {cn -eq $input}
$model = gwmi -class win32_computersystem -ComputerName $input | select Model

if ($comp -eq $null)
{Write-Warning "Computer not found in AD"}
Else
{$model}
