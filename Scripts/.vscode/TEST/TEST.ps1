$searchButton_Click = {
    get-aduser $userInput.text -Properties * | Select-Object Name, Office, Description | Out-GridView
}
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'TEST.designer.ps1')
$Form1.ShowDialog()