Get-CimInstance -ClassName win32_product | 
Where-Object {$_.Name -like "*office*"} |
Select-Object Name