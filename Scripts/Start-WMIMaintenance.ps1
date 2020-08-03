<#
.SYNOPSIS
    Maintenance script for Windows Management Instrumentation
.DESCRIPTION
    This script can perform management tasks such as rebuilding the WMI repository. On Windows 6.x and above, the default behaviour of this script
    is to salvage the WMI repository first. If that doesn't give any successful results, you'll have the option add the Reset parameter
.PARAMETER Task
    Specify a maintenance task to perform
 
    Valid tasks:
    - Rebuild
.PARAMETER Reset
    Enables you to reset the WMI repository instead of the default option that is to salvage (only for Windows 6.x and above)
.EXAMPLE     
     .\Start-WMIMaintenance -Task Rebuild -Verbose     
     Rebuilds the WMI repository on the local system, showing verbose output 
.NOTES     
     Script name: Start-WMIMaintenance.ps1     
     Version:     1.0     
     Author:      Nickolaj Andersen     
     Contact:     @NickolajA     
     DateCreated: 2015-02-11 
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [parameter(Mandatory=$true)]
    [ValidateSet("Rebuild")]
    [string]$Task,
    [parameter(Mandatory=$false)]
    [switch]$Reset
)
Begin {
    # Stop Windows Management Instrumentation dependent services
    $RunningServicesArrayList = New-Object -TypeName System.Collections.ArrayList
    foreach ($Service in (Get-Service -Name Winmgmt).DependentServices) {
        if ($Service.Status -like "Running") {
            $RunningServicesArrayList.Add($Service.Name) | Out-Null
            Write-Verbose -Message "Stopping Winmgmt dependent service '$($Service.Name)'"
            Stop-Service -Name $Service.Name -Force -ErrorAction Stop
        }
    }
    try {
    # Stop Windows Management Instrumentation service
        Write-Verbose -Message "Stopping Windows Management Instrumentation service"
        Stop-Service -Name "Winmgmt" -Force -ErrorAction Stop
    }
    catch {
        Throw "Unable to stop 'Winmgmt' service"
    }
 
    # Contruct an array of locations to the WMI repository
    $WMIPaths = @((Join-Path -Path $env:SystemRoot -ChildPath "System32\wbem"),(Join-Path -Path $env:SystemRoot -ChildPath "SysWOW64\wbem"))
}
Process {
    if ($PSBoundParameters.Values -contains "Rebuild") {
        # Re-register WMI executables
        foreach ($WMIPath in $WMIPaths) {
            if (Test-Path -Path $WMIPath -PathType Container) {
                $WMIExecutables = @("unsecapp.exe","wmiadap.exe","wmiapsrv.exe","wmiprvse.exe","scrcons.exe")
                foreach ($WMIExecutable in $WMIExecutables) {
                    $CurrentExecutablePath = (Join-Path -Path $WMIPath -ChildPath $WMIExecutable)
                    if (Test-Path -Path $CurrentExecutablePath -PathType Leaf) {
                        Write-Verbose -Message "Registering: $($CurrentExecutablePath)"
                        Start-Process -FilePath $CurrentExecutablePath -ArgumentList "/RegServer" -Wait
                    }
                }
            }
            else {
                Write-Warning -Message "Unable to locate path '$($WMIPath)'"
            }
        }
 
        # Reset WMI repository
        if ([System.Environment]::OSVersion.Version.Major -ge 6) {
            $WinMgmtPath = Join-Path -Path $env:SystemRoot -ChildPath "\System32\wbem\winmgmt.exe"
            if ($PSBoundParameters["Reset"]) {
                Write-Verbose -Message "Resetting WMI repository"
                Start-Process -FilePath $WinMgmtPath -ArgumentList "/resetrepository" -Wait
            }
            else {
                Write-Verbose -Message "Salvaging WMI repository"
                Start-Process -FilePath $WinMgmtPath -ArgumentList "/salvagerepository" -Wait
            }
        }
        else {
            foreach ($WMIPath in $WMIPaths) {
                if (Test-Path -Path $WMIPath -PathType Container) {
                    $MOFFiles = Get-ChildItem $WMIPath -Include "*.mof","*.mfl" -Recurse
                    foreach ($MOFFile in $MOFFiles) {
                        $CurrentMOFFilePath = (Join-Path -Path $WMIPath -ChildPath $MOFFile)
                        Write-Verbose -Message "Compiling MOF: $($CurrentMOFFilePath)"
                        Start-Process -FilePath (Join-Path -Path $env:SystemRoot -ChildPath "\System32\wbem\mofcomp.exe") -ArgumentList $CurrentMOFFilePath -Wait
                    }
                }
                else {
                    Write-Warning -Message "Unable to locate path '$($WMIPath)'"
                }
            }
            if ([System.Environment]::OSVersion.Version.Minor -eq 1) {
                Start-Process -FilePath (Join-Path -Path $env:SystemRoot -ChildPath "\System32\rundll32.exe") -ArgumentList wbemupgd,UpgradeRepository
            }
            else {
                Start-Process -FilePath (Join-Path -Path $env:SystemRoot -ChildPath "\System32\rundll32.exe") -ArgumentList wbemupgd,RepairWMISetup
            }
        }
    }
}
End {
    # Start Windows Management Instrumentation service
    Write-Verbose -Message "Starting Windows Management Instrumentation service"
    Start-Service -Name "Winmgmt"
 
    # Start previously running services that was stopped by this script
    foreach ($Service in $RunningServicesArrayList) {
        Write-Verbose -Message "Starting service '$($Service)'"
        Start-Service -Name $Service -ErrorAction SilentlyContinue
    }
}