# Will remove the win32 user profile from the specified computer. 
# Be sure to change computername and username.

Get-CimInstance -ComputerName d-laurelmsr2 -Class Win32_UserProfile |
Where-Object { $_.LocalPath.split('\')[-1] -eq 'robbief' } |
Remove-CimInstance

