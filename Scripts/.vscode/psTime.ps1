$time = New-Object -ComObject wscript.Shell

while (1) {
    $time.sendkeys('+{F15}')
    Start-Sleep -Seconds 60
}
