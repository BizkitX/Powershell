$OUs = "OU=NASA,OU=Mott MacDonald Group,DC=mottmac,DC=group,DC=int”, "OU=NASA,OU=Mott MacDonald Group - Win10,DC=mottmac,DC=group,DC=int”

Write-Host "Please wait...Your file will open automatically when complete." -ForegroundColor Yellow

Foreach ($OU in $OUs)
{
Get-ADComputer -Filter {OperatingSystemVersion -Like "*15063*"} -SearchBase $OU -Property * | `
select Name, Description, OperatingSystemVersion, LastLogonDate, Enabled | `
Export-CSV c:\temp\All1703.csv -NoTypeInformation -Encoding UTF8
}

Write-Host "All1703.csv file saved to 'c:\temp' folder" -ForegroundColor Green

.\temp\All1703.csv