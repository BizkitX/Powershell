$Computers = Import-Csv -Path "C:\Users\wal63291\Desktop\DPlist.csv" -Header "Name"
ForEach ($Computer In $Computers)
{
  Try
  {
    Get-ADComputer -Identity $Computer.Name -Properties Name, operatingSystem |Select Name, OperatingSystem | Export-Csv C:\Users\wal63291\Desktop\DPlist2.csv -Append -NoTypeInformation
  }
  Catch
  {
    $Computer.Name + " not in AD"
  }
}