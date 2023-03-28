###############################
#                             #
# Dixie EPA Powershell Module #
#                             #
###############################

#Lists all currently disabled users in Active Directory and their last logon date/time.
function Get-DisabledUsers {
    
    Get-ADUser -Filter {Enabled -eq $false} -Properties Name, LastLogonDate | Select-Object Name, LastLogonDate | Sort-Object Name
    
}
#Lists all currently disabled computers in Active Directory and their last logon date/time.
function Get-DisabledComputers {
    
    Get-ADComputer -Filter {Enabled -eq $false } -Properties Name, LastLogonDate | Select-Object Name, LastLogonDate | Sort-Object Name
    
}
#Will give current AD password status.
function Get-PasswordExpiryDate {
    param(
    [Parameter(Mandatory = $True)]
    [string]
    $SamAccountName
)

Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'" -Properties "DisplayName", "PasswordExpired", "PasswordLastSet", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property Displayname, PasswordLastSet, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} |
Format-List

$PasswordExpired = (Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'" -Properties "PasswordExpired").PasswordExpired
If ($PasswordExpired -eq "True")
{ 
    Write-Host "Password is Expired!" -ForegroundColor Red
}
else {
    Write-Host "Password is still good." -ForegroundColor Green
}
}


function Start-PowershellRemote {
    param(
    [parameter(Mandatory = $true)]
    [string]$ComputerName
)

$creds = Get-Credential -Message "Please enter your ADMIN credentials."
$Connection = Test-Connection $ComputerName -Count 1 -Quiet

If ($Connection -eq "True")
{
PsExec.exe \\$ComputerName -s winrm.cmd quickconfig -q
Enter-PSSession -ComputerName $ComputerName -Credential $creds
}

Else
{
Write-Host -ForegroundColor Red "The computer is unreachable"
}
    
}

# Will remove the win32 user profile from the specified computer. 
function Remove-WindowsProfile {
    param(
      [parameter(Mandatory)] 
        [string[]] 
        $ComputerName,
    
      [Parameter(Mandatory)]
        [string[]]
        $UserName
    
    )
    Get-CimInstance -ComputerName $ComputerName -Class Win32_UserProfile |
    Where-Object { $_.LocalPath.split('\')[-1] -eq $UserName } |
    Remove-CimInstance -Verbose
    
    }

    #Enables Windows Remote Management on a remote machine.
function Enable_WinRM {
    
    param(
        [parameter(Mandatory)]
        [string]$ComputerName
    )
    
    $Connection = Test-Connection $ComputerName -Count 1 -Quiet
    
    If ($Connection -eq "True")
    {
    PsExec.exe \\$ComputerName -s winrm.cmd quickconfig -q
    }
    
    Else
    {
    Write-Host -ForegroundColor Red "The computer is unreachable"
    }

}

#Starts a PowerShell Remote Session.
function Start-PSRemote {
    param(
    [parameter(Mandatory)]
    [string]$ComputerName
)

$creds = Get-Credential -Message "Please enter your ADMIN credentials."
$Connection = Test-Connection $ComputerName -Count 1 -ErrorAction SilentlyContinue

If ($Connection -eq "$true")
{
PsExec.exe \\$ComputerName -s winrm.cmd quickconfig -q
Enter-PSSession -ComputerName $ComputerName -Credential $creds
}

Else
{
Write-Host -NoNewline -ForegroundColor Red "The computer is unreachable"
}
    
}

#Get the drive space of a device
function Get-DriveSpace {
    param(
    [Parameter(Mandatory=$true)]
    [string]$ComputerName
)

Get-WmiObject -Class Win32_Volume -ComputerName $ComputerName -Credential (Get-Credential) | 
    Format-Table -AutoSize DriveLetter, Label, @{Label="Free(GB)"; Expression={"{0:N0}" -f ($_.FreeSpace/1GB)}}, @{Label="%Free"; Expression={"{0:P0}" -f ($_.FreeSpace/$_.Capacity)}}
    
}