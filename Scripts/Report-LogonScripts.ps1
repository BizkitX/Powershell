$empIDs = Get-Content C:\Users\wal63291\Desktop\PPLEmpIDs.txt

foreach ($empID in $empIDs)
{
Get-ADUser -Filter {EmployeeNumber -eq $EmpID} -Properties Name, office, scriptpath | `
Select-Object Name, Office, ScriptPath | `
Export-Csv C:\users\wal63291\Desktop\UsersLogonScripts.csv -Append
}