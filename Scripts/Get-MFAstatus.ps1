Connect-MsolService
 Get-MsolUser -All | select DisplayName,BlockCredential,UserPrincipalName,@{N="MFA Status"; E={ if( $_.StrongAuthenticationRequirements.State -ne $null){ $_.StrongAuthenticationRequirements.State} else { "Disabled"}}}