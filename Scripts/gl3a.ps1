write-output "Task Kicker - Gavin Lock 2018"
$title = "              Task Kicker"
$message = "Please choose timezone of the computer destination"

$E = New-Object System.Management.Automation.Host.ChoiceDescription "&Eastern Standard Time", `
    "Set to Eastern Standard Time"

$C = New-Object System.Management.Automation.Host.ChoiceDescription "&Central Standard Time", `
    "Set to Central Standard Time"

$M = New-Object System.Management.Automation.Host.ChoiceDescription "&Mountain Standard Time", `
    "Set to Mountain Time"

$P = New-Object System.Management.Automation.Host.ChoiceDescription "&Pacific Standard Time", `
    "Set to Pacific Standard Time"


$options = [System.Management.Automation.Host.ChoiceDescription[]]($E,$C,$M,$P)

$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
# End popup 
# Set-ExecutionPolicy restricted
switch ($result)
    {
        0 {TZUTIL /S "Eastern Standard Time"}
        1 {TZUTIL /S "Central Standard Time"}
        2 {TZUTIL /S "Mountain Standard Time"}
        3 {TZUTIL /S "Pacific Standard Time"}
    }

#set lid to no action
powercfg -SETACVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0

#check if laptop or desktop - add in DA group SG_NASA_DA_CLIENT_SETTINGS_REV1 if laptop
$hardwaretype = gwmi -Class win32_computersystem | select -ExpandProperty PCSystemType

If ($hardwaretype -eq 2)
{
Add-ADGroupMember -Identity "SG_NASA_DA_Client_Settings_rev1" -Members "$env:computername$"
}

#add mmna-domain users to local adminstrators
net localgroup administrators "mottmac\MMNA-Domain Users" /ADD

#Uninstall Calendar, Mail, onenote,xbox,zune:
Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage  
Get-AppxPackage *OneNote* | Remove-AppxPackage
Get-AppxPackage *xbox* | Remove-AppxPackage
Get-AppxPackage *zunemusic* | Remove-AppxPackage
Get-AppxPackage *zunevideo* | Remove-AppxPackage
Get-AppxPackage *skype* | Remove-AppxPackage

#run SCCM tasks
write-output "Application Deployment Evaluation Cycle"
([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000121}’)
write-output "Discovery Data Collection Cycle"
([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000003}’)
write-output "File Collection Cycle"
([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000010}’)
write-output "Hardware Inventory Cycle"
([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000001}’)
write-output "Machine Policy Retrieval Cycle"
([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000021}’)
write-output "Machine Policy Evaluation Cycle"
([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000022}’)
write-output "Software Inventory Cycle"
([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000002}’)
write-output "Software Metering Usage Report Cycle"
([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000031}’)
write-output "Software Updates Assignments Evaluation Cycle"	
([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000108}’)
write-output "Software Update Scan Cycle"
([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000113}’)
write-output "State Message Refresh"
([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000111}’)
# last three may error out
write-output "User Policy Retrieval Cycle"
([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000026}’)
write-output "User Policy Evaluation Cycle"	
([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000027}’)
write-output "Windows Installers Source List Update Cycle"
([wmiclass]‘root\ccm:SMS_Client’).TriggerSchedule(‘{00000000-0000-0000-0000-000000000107}’)

#copy start menulayout and taskbar
Copy-Item -Path 'Internet Explorer.lnk' -Destination "c:\ProgramData\Microsoft\Windows\Start Menu\Programs\Windows Accessories"
Import-StartLayout –LayoutPath "startmenu.xml" -MountPath c:\
# put in Acad ipv6 variables
SETX FNP_IP_PRIORITY 6 /M
#copy default apps from xml file IE, PDFXchange
dism /online /Import-DefaultAppAssociations:"DefaultApps.xml"
#Enable SMB1.0
# Set-SmbServerConfiguration -EnableSMB1Protocol $true
# windows 7 smb1.0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB1 -Type DWORD -Value 1 –Force