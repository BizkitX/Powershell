$input = Read-Host "Enter Computername"
$system = gwmi -Class win32_bios -ComputerName $input
$serial = $system.serialnumber

$service = New-WebServiceProxy -Uri http://xserv.dell.com/services/assetservice.asmx?WSDL
$guid = [Guid]::NewGuid()

$info = $service.GetAssetInformation($guid,'warrantycheck',$serial)
$info.Entitlements