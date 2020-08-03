$Form1 = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Label]$Label1 = $null
[System.Windows.Forms.RichTextBox]$userInput = $null
[System.Windows.Forms.Button]$searchButton = $null
function InitializeComponent
{
$Label1 = (New-Object -TypeName System.Windows.Forms.Label)
$userInput = (New-Object -TypeName System.Windows.Forms.RichTextBox)
$searchButton = (New-Object -TypeName System.Windows.Forms.Button)
$Form1.SuspendLayout()
#
#Label1
#
$Label1.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]9.75,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]30,[System.Int32]19))
$Label1.Name = [System.String]'Label1'
$Label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]145,[System.Int32]16))
$Label1.TabIndex = [System.Int32]0
$Label1.Text = [System.String]'Enter EmployeeID'
$Label1.UseCompatibleTextRendering = $true
#
#userInput
#
$userInput.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]30,[System.Int32]38))
$userInput.Name = [System.String]'userInput'
$userInput.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]145,[System.Int32]25))
$userInput.TabIndex = [System.Int32]1
$userInput.Text = [System.String]''
#
#searchButton
#
$searchButton.BackColor = [System.Drawing.SystemColors]::HotTrack
$searchButton.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]30,[System.Int32]69))
$searchButton.Name = [System.String]'searchButton'
$searchButton.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]145,[System.Int32]25))
$searchButton.TabIndex = [System.Int32]2
$searchButton.Text = [System.String]'Search'
$searchButton.UseCompatibleTextRendering = $true
$searchButton.UseVisualStyleBackColor = $false
$searchButton.add_Click($searchButton_Click)
#
#Form1
#
$Form1.BackColor = [System.Drawing.SystemColors]::GrayText
$Form1.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]206,[System.Int32]170))
$Form1.Controls.Add($searchButton)
$Form1.Controls.Add($userInput)
$Form1.Controls.Add($Label1)
$Form1.ForeColor = [System.Drawing.Color]::White
$Form1.Text = [System.String]'Form1'
$Form1.ResumeLayout($false)
Add-Member -InputObject $Form1 -Name base -Value $base -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name Label1 -Value $Label1 -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name userInput -Value $userInput -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name searchButton -Value $searchButton -MemberType NoteProperty
}
. InitializeComponent
