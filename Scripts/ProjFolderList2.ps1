Get-ChildItem -path "C:\users\wal63291\Desktop" -Directory -Recurse -Depth 2 | 
Select-Object FullName | 
ForEach-Object -Process{New-Object -TypeName PSObject -Property @{Name =$_.FullName;Size = (Get-ChildItem -path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue | 
Measure-Object -Property Length -Sum ).Sum/1gb}} | 
Select-Object Name, @{Name="Size(GB)";Expression={("{0:N2}" -f($_.Size))}} |
Export-Csv "insert path"