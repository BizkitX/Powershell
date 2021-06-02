Get-ChildItem -Path "C:\Users\wal63291\Desktop\" -Recurse -Depth 2 -Force -ErrorAction SilentlyContinue | `
Measure-Object -Property Length -Sum | `
Select-Object FullName, {$_.Sum/1GB} | `
Export-Csv c:\temp\testList.csv