$photo = [byte[]](Get-Content C:\Users\wal63291\Desktop\SammyLyncPic.JPG –Encoding byte) 
Set-ADUser bur44167 -Replace @{thumbnailPhoto=$photo}