# Define the Office 2019 product code
$officeProductCode = "{90160000-008C-0409-1000-0000000FF1CE}"

# Check if Office Standard 2019 is installed
$officeInstalled = Get-WmiObject -Class Win32_Product | Where-Object { $_.IdentifyingNumber -eq $officeProductCode }

if ($officeInstalled) {
  # Uninstall Office Standard 2019
  $uninstallCommand = "msiexec.exe /i $officeProductCode /qn"
  Start-Process -FilePath $uninstallCommand -Wait | Out-Null
}