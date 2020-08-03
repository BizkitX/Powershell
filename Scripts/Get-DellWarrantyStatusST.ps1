$serial = Read-Host "Enter serial/service tag"

$service = New-WebServiceProxy -Uri http://xserv.dell.com/services/assetservice.asmx?WSDL
$guid = [Guid]::NewGuid()

$info = $service.GetAssetInformation($guid,'warrantycheck',$serial)
$info.Entitlements