# Will remove the win32 user profile from the specified computer. 
# Be sure to change computername and username.

Get-CimInstance -ComputerName l-dcentraltest2 -Class Win32_UserProfile |
Where-Object { $_.LocalPath.split('\')[-1] -eq 'general.services' } |
Remove-CimInstance -Verbose

