param(
    [Parameter(Mandatory=$true)]
    [string]$ComputerName ='localhost'
)
    


try {
    $programs = Get-CimInstance -Class win32_product -ComputerName $ComputerName -ErrorAction Stop -Filter "Name like '%'" |
               Select-Object DisplayName, Version, InstallDate |
               Sort-Object DisplayName
    $programs | Format-Table
} catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
}