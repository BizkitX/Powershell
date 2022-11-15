# Get the server name
$hostName = hostname

# Define the email address to send notifications to
$toAddress = "brianwallace@dixieepa.com"

# Send the notification
Send-MailMessage -To $toAddress -From "it@dixieepa.com" -SmtpServer smtp.ad.dixieelectric.coop -Subject "ALERT! $hostName - Reboot" -Body "$hostName has rebooted."
