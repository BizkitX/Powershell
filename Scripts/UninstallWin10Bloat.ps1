Start-Transcript -Path c:\temp\UninstallWin10Bloat.log

# 3D Builder
Get-AppxPackage -allusers *3d* | Remove-AppxPackage -verbose

# Get Office
Get-AppxPackage -allusers *officehub* | Remove-AppxPackage -verbose

# Groove Music
Get-AppxPackage -allusers *zunemusic* | Remove-AppxPackage -verbose

# Mail/Calendar
Get-AppxPackage -allusers *windowscommunication* | Remove-AppxPackage -verbose

# Maps
Get-AppxPackage -allusers *windowsmaps* | Remove-AppxPackage -verbose

# Microsoft Solitaire Collection
Get-AppxPackage -allusers *solitairecollection* | Remove-AppxPackage -verbose

# Movies & TV
Get-AppxPackage -allusers *zunevideo* | Remove-AppxPackage -verbose

# OneNote
Get-AppxPackage -allusers *onenote* | Remove-AppxPackage -verbose

# Microsoft Phone Companion
Get-AppxPackage -allusers *windowsphone* | Remove-AppxPackage -verbose

# Skype
Get-AppxPackage -allusers *skypeapp* | Remove-AppxPackage -verbose

# Tips
Get-AppxPackage -allusers *getstarted* | Remove-AppxPackage -verbose

# Bing News & Weather
Get-AppxPackage -allusers *bing* | Remove-AppxPackage -verbose

# Xbox
Get-AppxPackage -allusers *xboxapp* | Remove-AppxPackage -verbose
Get-AppxPackage -allusers *Microsoft.XboxGamingOverlay* | Remove-AppxPackage -verbose

Stop-Transcript