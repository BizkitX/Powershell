# Will remove the win32 user profile from the specified computer. 
# Be sure to change computername and username.

function RemoveWindowsProfile {
param(
  [parameter(Mandatory)] 
    [string[]] 
    $ComputerName,

  [Parameter(Mandatory)]
    [string[]]
    $UserName

)
Get-CimInstance -ComputerName $ComputerName -Class Win32_UserProfile |
Where-Object { $_.LocalPath.split('\')[-1] -eq $UserName } |
Remove-CimInstance -Verbose

}

