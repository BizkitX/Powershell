param(
    [Parameter(Mandatory=$true)]
    [string]
    $ComputerName
    )
    
$Credentials = Get-Credential

Get-WmiObject –Class Win32_Volume -ComputerName $ComputerName -Credential $Credentials | Format-Table –auto DriveLetter,`
                  Label,`
                  @{Label=”Free(GB)”;Expression={“{0:N0}” –F ($_.FreeSpace/1GB)}},`
                  @{Label=”%Free”;Expression={“{0:P0}” –F ($_.FreeSpace/$_.Capacity)}}