Get-ADUser -Filter {manager -eq "CN=Kimberly Howell,OU=Users,OU=WHO,OU=US,DC=hmmg,DC=cc"} -Properties * |
select Name, samaccountname, Office|
Sort-Object -Property Office |
Format-Table -AutoSize Name, @{Expression={$_.samaccountname};Label="User ID"}, Office