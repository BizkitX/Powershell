$name = Read-Host -Prompt "Please enter computer name"
gwmi -ComputerName $name -Class win32_bios | select serialnumber