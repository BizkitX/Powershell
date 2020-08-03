 PARAM ([string]$LogFileDirectory = '\\us5005496\c$\Windows\CCM\Logs')
$appModelLogs = '"AppDiscovery.log" "AppEnforce.log" "AppIntentEval.log" "CcmExec.log "CAS.log" "CIAgent.log" "CIDownloader.log" "CIStateStore.log" "CIStore.log" "CITaskMgr.log" "DataTransferService.log" "DCMAgent.log" "DCMReporting.log" "execmgr.log" "LocationServices.log" "PolicyAgent.log"'
add-type -AssemblyName microsoft.VisualBasic
add-type -AssemblyName System.Windows.Forms
#find and launch cmtrace by creating a blank log file and opening
start (new-item $env:temp\tempEmptylog.log -type file -Force)
#set the last directory in the registry to the $LogFileDirectory
Set-ItemProperty -Path HKCU:\Software\Microsoft\Trace32 -Name "Last Directory" -Value $LogFileDirectory
start-sleep -Milliseconds 2000
[System.Windows.Forms.SendKeys]::SendWait("^o")
start-sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait($appModelLogs)
1..5|%{[System.Windows.Forms.SendKeys]::SendWait("{TAB}")}
[System.Windows.Forms.SendKeys]::SendWait(" ")
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
1..7|%{[System.Windows.Forms.SendKeys]::SendWait("{TAB}")}
[System.Windows.Forms.SendKeys]::SendWait(" ")