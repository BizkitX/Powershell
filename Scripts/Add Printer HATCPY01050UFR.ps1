$PrinterPath = "\\hat-print-vm\hatcpy01050ufr"
$net = New-Object -ComObject WScript.Network
$net.AddWindowsPrinterConnection($PrinterPath)