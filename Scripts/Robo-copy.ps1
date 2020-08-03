$source = Read-Host "Enter Source"
$destination = Read-Host "Enter Destination"

robocopoy /e /zb "$source" "$destination"