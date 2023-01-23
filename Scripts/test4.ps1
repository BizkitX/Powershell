Add-Type -AssemblyName System.Windows.Forms 
Add-Type -AssemblyName System.Drawing 

$form = New-Object System.Windows.Forms.Form
$form.Text = "DixieEPA Printer Install"
$form.Size = New-Object System.Drawing.Size(300,200)

$label = New-Object System.Windows.Forms.Label
$label.Text = "Select a printer:"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(10,10)
$form.Controls.Add($label)

$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Location = New-Object System.Drawing.Point(10,30)
$comboBox.Size = New-Object System.Drawing.Size(200,20)
$form.Controls.Add($comboBox)

$printers = Import-Csv -Path "c:\temp\printers.csv"
foreach ($printer in $printers)
{
    $comboBox.Items.Add($printer.Name)
}

$label2 = New-Object System.Windows.Forms.Label
$label2.Text = "Enter the remote computer name:"
$label2.AutoSize = $true
$label2.Location = New-Object System.Drawing.Point(10,60)
$form.Controls.Add($label2)

$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Location = New-Object System.Drawing.Point(10,80)
$textbox.Size = New-Object System.Drawing.Size(200,20)
$form.Controls.Add($textbox)

$button = New-Object System.Windows.Forms.Button
$button.Text = "Install"
$button.AutoSize = $true
$button.Location = New-Object System.Drawing.Point(10,110)
$form.Controls.Add($button)

$button.Add_Click({
    $selectedPrinter = $comboBox.SelectedItem
    $computerName = $textbox.Text
    if(Test-Connection -ComputerName $computerName -Quiet){
        Add-Printer -ConnectionName \\26030print\$selectedPrinter -ComputerName $computerName
    }
    else{
        [System.Windows.Forms.MessageBox]::Show("The remote computer '$computerName' could not be reached", "Error", 0, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

$form.ShowDialog()