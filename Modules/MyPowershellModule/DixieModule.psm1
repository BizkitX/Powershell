###############################
#                             #
# Dixie EPA Powershell Module #
#                             #
###############################

function Get-DisabledUsers {
    
    Get-ADUser -Filter {Enabled -eq $false} -Properties Name, LastLogonDate | Select-Object Name, LastLogonDate | Sort-Object Name
    
}

