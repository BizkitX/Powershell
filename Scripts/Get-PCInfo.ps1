Param(
   [Parameter(Mandatory)]
   [string]$ComputerName
)
 Write-Host "Loading..."
$Connection = Test-Connection $ComputerName -Count 1 -Quiet
 
if ($Connection -eq "True"){
 
   $ComputerHW = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $ComputerName | Select-Object Manufacturer,Model | Format-Table -AutoSize
 
   $ComputerCPU = Get-WmiObject win32_processor -ComputerName $ComputerName | Select-Object DeviceID,Name | Format-Table -AutoSize
 
   $ComputerRam_Total = Get-WmiObject Win32_PhysicalMemoryArray -ComputerName $ComputerName | Select-Object MemoryDevices, @{Label="MaxCapacity(GB)"; Expression={$_.MaxCapacity/1MB}} | Format-Table -AutoSize
 
   $ComputerRAM = Get-WmiObject Win32_PhysicalMemory -ComputerName $ComputerName | Select-Object DeviceLocator,Manufacturer,PartNumber,@{Label="Capacity(GB)"; Expression={$_.Capacity/1GB}} ,Speed | Format-Table -AutoSize
 
   $ComputerDisks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $ComputerName | Select-Object DeviceID,VolumeName,@{Label="Size(GB)"; Expression={$_.Size/1GB} } ,@{Label="FreeSpace(GB)"; Expression={$_.FreeSpace/1GB} } | Format-Table -AutoSize
 
   $ComputerOS = (Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName).Version
 
   switch -Wildcard ($ComputerOS){
      "6.1.7600" {$OS = "Windows 7"; break}
      "6.1.7601" {$OS = "Windows 7 SP1"; break}
      "6.2.9200" {$OS = "Windows 8"; break}
      "6.3.9600" {$OS = "Windows 8.1"; break}
      "10.0.*" {$OS = "Windows 10"; break}
      default {$OS = "Unknown Operating System"; break}
   }
 
   Write-Host "Computer Name: $ComputerName"
   Write-Host "Operating System: $OS"
   Write-Output $ComputerHW
   Write-Output $ComputerCPU
   Write-Output $ComputerRam_Total
   Write-Output $ComputerRAM
   Write-Output $ComputerDisks
   }
else {
   Write-Host -ForegroundColor Red @"
 
Computer is not reachable or does not exists.
 
"@
}