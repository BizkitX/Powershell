###############################
#                             #
# Dixie EPA Powershell Module #
#                             #
###############################

function Get-DisabledUsers {
    
    Get-ADUser -Filter {Enabled -eq $false} -Properties Name, LastLogonDate | Select-Object Name, LastLogonDate | Sort-Object Name
    
}

function Get-DisabledComputers {
    
    Get-ADComputer -Filter {Enabled -eq $false } -Properties Name, LastLogonDate | Select-Object Name, LastLogonDate | Sort-Object Name
    
}

function Get-PasswordExpiryDate {
    param(
    [Parameter(Mandatory = $True)]
    [string]
    $Name
)

Get-ADUser -Filter "SamAccountName -eq '$Name'" -Properties "DisplayName", "PasswordExpired", "PasswordLastSet", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property Displayname, PasswordLastSet, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} |
Format-List

$PasswordExpired = (Get-ADUser -Filter "SamAccountName -eq '$Name'" -Properties "PasswordExpired").PasswordExpired
If ($PasswordExpired -eq "True")
{ 
    Write-Output "Password is Expired!"
}
else {
    Write-Output "Password is still good."
}
}

