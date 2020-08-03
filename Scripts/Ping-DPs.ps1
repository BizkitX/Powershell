get-content C:\dpList.txt | Where-Object {!($_ -match "#")} |  
ForEach-Object { 
if(Test-Connection -ComputerName $_ -Count 1 -ea silentlycontinue) 
    { 
     # if the Host is available then just write it to the screen 
     write-host "Available host ---> "$_ -BackgroundColor Green -ForegroundColor White 
      
    } 
else 
    { 
      
     if(!(Test-Connection -ComputerName $_ -Count 4 -ea silentlycontinue)) 
       { 
        # If the host is still unavailable for 4 full pings, write error
        write-host "Unavailable host ------------> "$_ -BackgroundColor Red -ForegroundColor White 
       }
     }
     }  