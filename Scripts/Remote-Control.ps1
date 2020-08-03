$Cmrcviewer = 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\i386\CmRcViewer.exe'
$compname = Read-Host "Computer Name"
& $Cmrcviewer $compname