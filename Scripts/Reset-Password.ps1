$user = Read-Host "Enter UserID"
$password = Read-Host "Enter new password"

Write-Host -ForegroundColor Yellow -BackgroundColor Black "Resetting user password..."

Set-ADAccountPassword $user -NewPassword (ConvertTo-SecureString -AsPlainText $password -Force) -Reset