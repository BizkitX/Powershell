$hardwaretype = gwmi -Class win32_computersystem | select -ExpandProperty PCSystemType
 
If ($hardwaretype -eq 2)
{
Add-ADGroupMember -Identity "SG_NASA_DA_Client_Settings_rev1" -Members "$env:computername$"
}