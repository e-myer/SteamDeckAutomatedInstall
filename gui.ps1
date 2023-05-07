. ".\SteamDeckAutomatedInstall.ps1"

$tasks = "disable-hibernation", "reduce-fan-speed", "install-drivers", "install-redistributables", "install-vigembus", "install-deckutils", "install-rivatuner", "install-steamdecktools", "install-equalizerapo", "set-rivatuner-run-at-login", "deny-error-reporting-consent-steamdecktools-(will disable auto updates)", "set-fan-control-on-login", "deny-error-reporting-consent-steamdecktools", "set-fan-control-on-login", "set-performanceoverlay-on-login", "set-powercontrol-on-login", "set-steam-controller-on-login", "create-desktop-shortcut-for-steamdeck-tools"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please make a selection from the list below:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)

$listBox.SelectionMode = 'MultiExtended'

foreach ($task in $tasks) {
[void] $listBox.Items.Add($task)
}

$listBox.Height = 70
$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()

$selection = $listBox.SelectedItems -split "`n"


if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    foreach ($element in $selection) {
        Invoke-Expression $element
    }
}