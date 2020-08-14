function Get-SystemInfo {
    [CmdletBinding()]
    param (
        [string[]]$ComputerName,
        [string]$ErrorLog
    )
    
    begin {
        
    }
    
    process {
        foreach ($computer in $ComputerName) {
            $os = Get-WmiObject -class win32_operatingsystem -ComputerName $computer
            $comp = Get-WmiObject -class win32_computersystem -ComputerName $computer
            $bios = Get-WmiObject -Class win32_bios -ComputerName $computer

            $props = @{'ComputerName' = $computer;
                        'OSVersion' = $os.version;
                        'BIOSSerial' = $bios.serialnumber;
                        'Manufacturer' = $comp.Manufacturer;
                        'Model' = $comp.model}
            $obj = New-Object -TypeName psobject -Property $props
            
            Write-Output $obj
        }
    }
    
    end {
        
    }
}

Get-SystemInfo -ErrorLog x.txt -ComputerName localhost, us000000hm