Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "The Internet Self-surfer"
$form.Size = New-Object System.Drawing.Size(400,180)
$form.StartPosition = "CenterScreen"

# Label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Please input your URL, and i will open it."
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(20,20)

# Textbox
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Size = New-Object System.Drawing.Size(340,20)
$textbox.Location = New-Object System.Drawing.Point(20,50)

# Button
$button = New-Object System.Windows.Forms.Button
$button.Text = "OK"
$button.Size = New-Object System.Drawing.Size(80,30)
$button.Location = New-Object System.Drawing.Point(150,85)

# Function to detect likely download link
function Is-DownloadLink($url) {
    $extensions = @(
        ".zip",".exe",".msi",".rar",".7z",".tar",".gz",".pdf",
        ".mp3",".mp4",".mkv",".iso",".img",".deb",".apk",".dmg"
    )

    foreach ($ext in $extensions) {
        if ($url.ToLower().EndsWith($ext)) {
            return $true
        }
    }
    return $false
}

# Button Click Event
$button.Add_Click({

    $url = $textbox.Text.Trim()

    if ([string]::IsNullOrWhiteSpace($url)) {
        [System.Windows.Forms.MessageBox]::Show("Please enter a URL.")
        return
    }

    if (Is-DownloadLink $url) {

        $file = [System.IO.Path]::GetFileName($url)

        $result = [System.Windows.Forms.MessageBox]::Show(
            "Do you want to download $file from source $url ?",
            "Download Confirmation",
            [System.Windows.Forms.MessageBoxButtons]::YesNo
        )

        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            Start-Process $url
        }

    }
    else {

        Start-Process $url

        [System.Windows.Forms.MessageBox]::Show(
            "Waiting for browser session to end.",
            "Browser Started"
        )

    }

})

$form.Controls.Add($label)
$form.Controls.Add($textbox)
$form.Controls.Add($button)

$form.Topmost = $true
$form.Add_Shown({$textbox.Focus()})

[void]$form.ShowDialog()