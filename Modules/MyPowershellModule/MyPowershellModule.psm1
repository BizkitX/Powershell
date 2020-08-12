############################################
##  Created by: Brian Wallace             ##
##  Modified: 2/8/2018                   ##
############################################

function Get-Computer
{
$last = Read-Host "Enter the users last name"
$info = Get-ADComputer -Filter " Description -like '*$last*' " -Properties Name, Description | 
Select-Object Name, Description |
Format-Table -AutoSize

Write-Host -ForegroundColor Cyan "Searching for computer..."

if ($info -eq $null)
{Write-Warning "User's last name not found"}
else
{$info}
}

function Get-BitlockerKey
{
$input= Read-Host "Enter computername"
$computer= Get-ADComputer -Filter {cn -eq $input}
if ($computer -eq $null)
{Write-Warning "Failed...Computer not found in AD"}
Else
{
Get-ADObject -Filter {objectclass -eq 'msFVE-RecoveryInformation'} -SearchBase $computer.DistinguishedName -Properties 'msFVE-RecoveryPassword' | 
Select-Object-Object @{Expression={$_.'msFVE-RecoveryPassword'};Label="Bitlocker Recovery Key"} |
Out-File -Verbose C:\Users\wal63291\Desktop\RecoveryKeys\$input.txt
}
}

function Get-Description
{
$comp = Read-Host "Enter computer name"
Get-ADComputer $comp -Properties * | Select-Object description
}

function Get-MappedDrives
{
$comp = Read-Host "Enter computername"
$info = Get-WmiObject -Class win32_mappedlogicaldisk -ComputerName $comp | 
Select-Object Name, ProviderName |
Format-Table -AutoSize

if ($info -eq $null)
{Write-Warning "Computer is either offline or not found in AD"}
else
{$info}
}

function Get-Model
{
$input = read-host "Enter the computer name"
$comp = Get-ADComputer -Filter {cn -eq $input}
$model = Get-WmiObject -class win32_computersystem -ComputerName $input | Select-Object Model

if ($comp -eq $null)
{Write-Warning "Computer not found in AD"}
Else
{$model}
}

function Get-OfficePhoneList
{
$office = Read-Host "Enter office 3 letter prefix"
Get-ADUser -Filter {enabled -eq $True -and msRTCSIP-Line -like "tel*"} -SearchBase "OU=$office,OU=US,OU=North America,OU=NASA,OU=Mott MacDonald Group,DC=Mottmac,DC=group,DC=int" -Properties * |
Select-Object-Object Name, msRTCSIP-Line, Mobile |
Export-Csv -Verbose C:\Users\wal63291\Desktop/phonelist.csv
}

function Get-OSInstallDate
{
$comp = Read-Host "Enter computername"
([WMI]'').ConvertToDateTime((Get-WmiObject Win32_OperatingSystem -ComputerName $comp).InstallDate)
}

function Get-RAM
{
$name = Read-Host "Enter computername"
Get-WmiObject -class Win32_PhysicalMemory -ComputerName $name | 
Measure-Object -Property capacity -Sum | 
Select-Object @{N="Total Physical Ram"; E={[math]::round(($_.Sum / 1GB),2)}} |
Format-Table -AutoSize
}

function Get-ServiceTag
{
$name = Read-Host -Prompt "Please enter computer name"
Get-WmiObject -ComputerName $name -Class win32_bios | Select-Object serialnumber
}

function Get-UserInfo
{
$user = Read-Host "Enter users first, last, or full name"
$info = Get-ADUser -Filter "Name -like '*$user*'" -Properties * | 
Select-Object Name, @{Expression={$_.samaccountname};Label="User ID"}, Description, Enabled, LockedOut, Office, @{Expression={$_."msRTCSIP-Line"};Label="Lync Number"}, EmailAddress |
Sort-Object Name

Write-Host -ForegroundColor Cyan "Searching for user information..."

if ($info -eq $null)
{Write-Warning "User not found"}
else
{
$info
}
}

function Get-VidCardInfo
{
$comp = Read-Host "Enter computername"
Get-WmiObject -Class cim_videocontroller -ComputerName $comp | Select-Object name,driverversion
}

function Get-LoggedOnUser
{
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ComputerName
        )
        
        $ErrorActionPreference = "SilentlyContinue"
        
        $userID = (Get-WmiObject -Class win32_computersystem -ComputerName $ComputerName).username.Split("\")[1]
        
        
        
        if (Test-Connection $ComputerName -quiet -Count 1)
        {
         Write-Host -ForegroundColor Green "Computer $ComputerName is online"
         Write-Host -ForegroundColor Cyan "Loading User Information..."
         Get-ADUser $userID -Properties Name,Description,Office,TelephoneNumber | Select-Object Name, Description, Office, TelephoneNumber | Format-List
         }
         Else{
         Write-Host -ForegroundColor Red "Computer $ComputerName is offline"}
 }
 
 
 function Set-Description
 {
 $input = Read-Host "Enter computer name"
$comp = Get-ADComputer -filter {cn -eq $input}
If ($comp -eq $null)
{Write-Warning "Computer not found in AD"}
Else
{
$desc = Read-Host "Enter description"
Set-ADComputer $comp -Description $desc -Credential mottmac\adminwal63291
Write-Host -ForegroundColor Green "Complete"
}
}

function ExportADUsers
{
$OU = Read-Host "Enter the 3 letter office OU"
Get-ADUser -SearchBase "ou=users,ou=$OU,ou=us,dc=hmmg,dc=cc" -Properties * -Filter * | Select-Object Name, SamAccountName, Description, OfficePhone, ScriptPath |Export-Csv -NoTypeInformation "C:\Users\wal63291\Desktop\ADUserExport.csv"
}

 function Get-LastBoot
 {
 $computer = Read-Host "Enter computername"
 $time = Get-WmiObject Win32_OperatingSystem -ComputerName $computer -Credential mottmac\adminwal63291
               
 [Management.ManagementDateTimeConverter]::ToDateTime($time.LastBootUpTime)  
 
 }

 function Reset-Password
 {
 $user = Read-Host "Enter UserID"
$password = Read-Host "Enter new password"

Write-Host -ForegroundColor Yellow -BackgroundColor Black "Resetting user password..."

Set-ADAccountPassword $user -NewPassword (ConvertTo-SecureString -AsPlainText $password -Force) -Reset
}
Function Get-NICinfo
{

[cmdletbinding()]            
param (            
 [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]            
    [string[]]$ComputerName = $env:computername            
)                        
            
begin {}            
process {            
 foreach ($Computer in $ComputerName) {            
  if(Test-Connection -ComputerName $Computer -Count 1 -ea 0) {            
   try {            
    $Networks = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Computer -EA Stop | Where-Object {$_.IPEnabled}            
   } catch {            
        Write-Warning "Error occurred while querying $computer."            
        Continue            
   }            
   foreach ($Network in $Networks) {            
    $IPAddress  = $Network.IpAddress[0]            
    $SubnetMask  = $Network.IPSubnet[0]            
    $DefaultGateway = $Network.DefaultIPGateway            
    $DNSServers  = $Network.DNSServerSearchOrder            
    $IsDHCPEnabled = $false            
    If($network.DHCPEnabled) {            
     $IsDHCPEnabled = $true            
    }            
    $MACAddress  = $Network.MACAddress            
    $OutputObj  = New-Object -Type PSObject            
    $OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer.ToUpper()            
    $OutputObj | Add-Member -MemberType NoteProperty -Name IPAddress -Value $IPAddress            
    $OutputObj | Add-Member -MemberType NoteProperty -Name SubnetMask -Value $SubnetMask            
    $OutputObj | Add-Member -MemberType NoteProperty -Name Gateway -Value $DefaultGateway            
    $OutputObj | Add-Member -MemberType NoteProperty -Name IsDHCPEnabled -Value $IsDHCPEnabled            
    $OutputObj | Add-Member -MemberType NoteProperty -Name DNSServers -Value $DNSServers            
    $OutputObj | Add-Member -MemberType NoteProperty -Name MACAddress -Value $MACAddress            
    $OutputObj            
   }            
  }            
 }            
}            
            
end {}
}
Function Get-JavaVersion
{
$ComputerName = Read-Host "Computer Name"
Get-WmiObject -Class Win32_Product -ComputerName $ComputerName -Filter "Name like 'Java%'" | 
Select-Object Name, Version
}
Function DisableUserAccount
{
$input = Read-Host "Enter Employee Number"
$userID = Get-ADUser -Filter {extensionAttribute3 -eq $input}
if ($userID -eq $null)
{Write-Warning "UserID not found in AD"}
Else
{
Move-ADObject -Identity $userID -TargetPath "ou=Disabled User Accounts,dc=hmmg,dc=cc" -PassThru -Verbose -Confirm |
Disable-ADAccount -Verbose -Confirm
}
}
Function Get-DriveSpace
{
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ComputerName
        )
        
    $Credentials = Get-Credential
    
    Get-WmiObject –Class Win32_Volume -ComputerName $ComputerName -Credential $Credentials | Format-Table –auto DriveLetter,`
                      Label,`
                      @{Label=”Free(GB)”;Expression={“{0:N0}” –F ($_.FreeSpace/1GB)}},`
                      @{Label=”%Free”;Expression={“{0:P0}” –F ($_.FreeSpace/$_.Capacity)}}
}
function Get-DellWarrantyStatus
{
$input = Read-Host "Enter Computername"
$system = Get-WmiObject -Class win32_bios -ComputerName $input
$serial = $system.serialnumber

$service = New-WebServiceProxy -Uri http://xserv.dell.com/services/assetservice.asmx?WSDL
$guid = [Guid]::NewGuid()

$info = $service.GetAssetInformation($guid,'warrantycheck',$serial)
$info.Entitlements
}
function Get-PasswordExpiryDate
{
$user = Read-Host "User ID"

Get-ADUser $user –Properties "DisplayName", "PasswordLastSet", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property Displayname, PasswordLastSet, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}
}

function Ping-DPs
{
get-content C:\Users\wal63291\Documents\dpList.txt | Where-Object {!($_ -match "#")} |  
ForEach-Object { 
if(Test-Connection -ComputerName $_ -Count 1 -ea silentlycontinue) 
    { 
     # if the Host is available then just write it to the screen 
     write-host "Available host ---> "$_ -BackgroundColor Green -ForegroundColor White 
      
    } 
else 
    { 
      
     if(!(Test-Connection -ComputerName $_ -Count 4 -ea silentlycontinue)) 
       { 
        # If the host is still unavailable for 4 full pings, write error
        write-host "Unavailable host ------------> "$_ -BackgroundColor Red -ForegroundColor White 
       }
     }
     } 
}

function Remote-Control
{
$Cmrcviewer = 'C:\Program Files (x86)\ConfigMgr Console\bin\i386\CmRcViewer.exe'
$compname = Read-Host "Computer Name"
& $Cmrcviewer $compname
}

function Get-PCInfo
{
    Param(
        [string]$ComputerName
        )
         
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
        else 
        {
           Write-Host -ForegroundColor Red "Computer not reachable or does not exist."
        }
}
function Get-InstalledPrograms
{
    $comp = Read-Host "Please enter computername"
Get-WmiObject -Class win32reg_addremoveprograms -ComputerName $comp | Select-Object DisplayName, Version, InstallDate | Sort-Object DisplayName | Out-GridView
}
Function Get-USDisabledComputers
{
Get-ADComputer -Filter {Enabled -eq $false -and Name -like "US*"} -SearchBase "OU=Disabled Computers,OU=Dormant Accounts,OU=Mott MacDonald Group,DC=mottmac,DC=group,DC=int" -Properties Name, OperatingSystem, Description | Select-Object Name, OperatingSystem, Description | Sort-Object Name | Out-GridView
}

function Start-PowershellRemote
{
$ComputerName = Read-Host "Enter Computer Name"
$Connection = Test-Connection $ComputerName -Count 1 -Quiet

If ($Connection -eq "True")
{
PsExec.exe \\$ComputerName -s winrm.cmd quickconfig -q

Enter-PSSession -ComputerName $ComputerName -Credential mottmac\adminwal63291
}

Else
{
Write-Host -ForegroundColor Red "The computer is unreachable"
}
}

function Get-SoftwareCenterApps
{
$ComputerName = Read-Host "Enter Computer Name"

$Connection = Test-Connection -ComputerName $ComputerName -Count 1 -Quiet

If($Connection -eq "True")
{
PsExec.exe \\$ComputerName -s winrm.cmd quickconfig -q
Get-CimInstance -ClassName ccm_application -Namespace "root\ccm\clientsdk" -ComputerName $ComputerName | select Name, InstallState, PercentComplete | Sort-Object Name | Out-GridView
}

Else
{
Write-Host -ForegroundColor Red "Computer is unreachable"
}
}
