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

Get-ADUser -Filter "DisplayName -like '*$Name*'" –Properties "DisplayName", "PasswordExpired", "PasswordLastSet", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property Displayname, PasswordExpired, PasswordLastSet, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} |
Format-List
    
}

