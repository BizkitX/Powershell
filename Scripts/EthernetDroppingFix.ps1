Get-NetAdapter | Where { $_.InterfaceDescription -like "Realtek USB GbE Family Controller*" } | % {
	Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName "Energy-Efficient Ethernet" -DisplayValue "Disabled"
	Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName "Idle Power Saving" -DisplayValue "Disabled"
	Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName "Selective Suspend" -DisplayValue "Disabled"
	
}