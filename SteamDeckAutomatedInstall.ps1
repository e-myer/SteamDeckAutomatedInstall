# DPI Adjustment found at https://stackoverflow.com/questions/35233182/how-can-i-change-windows-10-display-scaling-programmatically-using-c-sharp
$source = @’
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
public static extern bool SystemParametersInfo(
                uint uiAction,
                uint uiParam,
                uint pvParam,
                uint fWinIni);
‘@
$apicall = Add-Type -MemberDefinition $source -Name WinAPICall -Namespace SystemParamInfo –PassThru

Clear

$ProgressPreference = 'SilentlyContinue'

function Save-Download {
    <#
    .SYNOPSIS
        Given a the result of WebResponseObject, will download the file to disk without having to specify a name.
    .DESCRIPTION
        Given a the result of WebResponseObject, will download the file to disk without having to specify a name.
    .PARAMETER WebResponse
        A WebResponseObject from running an Invoke-WebRequest on a file to download
    .EXAMPLE
        # Download Microsoft Edge
        $download = Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2109047&Channel=Stable&language=en&consent=1"
        $download | Save-Download 
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [Microsoft.PowerShell.Commands.WebResponseObject]
        $WebResponse,

        [Parameter(Mandatory = $false)]
        [string]
        $Directory = "."
    )

    $errorMessage = "Cannot determine filename for download."

    if (!($WebResponse.Headers.ContainsKey("Content-Disposition"))) {
        Write-Error $errorMessage -ErrorAction Stop
    }

    $content = [System.Net.Mime.ContentDisposition]::new($WebResponse.Headers["Content-Disposition"])
    
    $fileName = $content.FileName

    if (!$fileName) {
        Write-Error $errorMessage -ErrorAction Stop
    }

    if (!(Test-Path -Path $Directory)) {
        New-Item -Path $Directory -ItemType Directory
    }
    
    $fullPath = Join-Path -Path $Directory -ChildPath $fileName

    Write-Verbose "Downloading to $fullPath"

    $file = [System.IO.FileStream]::new($fullPath, [System.IO.FileMode]::Create)
    $file.Write($WebResponse.Content, 0, $WebResponse.RawContentLength)
    $file.Close()
}

function Get-Files {
    Write-Host "Downloading Required Files"
    Write-Host "-----------------------------------------------------------------------"

    Write-Host -NoNewline "- APU Chipset Drivers from Valve: "
    $download = Invoke-WebRequest -Uri "https://steamdeck-packages.steamos.cloud/misc/windows/drivers/Aerith%20Windows%20Driver_2302270303.zip"
    $download | Save-Download 
    Write-Host -ForegroundColor Green "Done"

    Write-Host -NoNewline "- Audio Drivers 1/2 from Valve (cs35l41): "
    $download = Invoke-WebRequest -Uri "https://steamdeck-packages.steamos.cloud/misc/windows/drivers/cs35l41-V1.2.1.0.zip"
    $download | Save-Download 
    Write-Host -ForegroundColor Green "Done"

    Write-Host -NoNewline "- Audio Drivers 2/2 from Valve (NAU88L21): "
    $download = Invoke-WebRequest -Uri "https://steamdeck-packages.steamos.cloud/misc/windows/drivers/NAU88L21_x64_1.0.6.0_WHQL%20-%20DUA_BIQ_WHQL.zip"
    $download | Save-Download 
    Write-Host -ForegroundColor Green "Done"

    Write-Host -NoNewline "- Wireless LAN Drivers from Windows Update: "
    Invoke-WebRequest -URI "https://catalog.s.download.windowsupdate.com/d/msdownload/update/driver/drvs/2022/11/05b73312-01e0-4e40-a991-93d11309b736_8cd43d4695c27a3f174b6e9c33034c100995e095.cab" -OutFile ".\WLAN_Drivers.cab"
    Write-Host -ForegroundColor Green "Done"

    Write-Host -NoNewline "- Bluetooth Drivers from Windows Update: "
    Invoke-WebRequest -URI "https://catalog.s.download.windowsupdate.com/d/msdownload/update/driver/drvs/2022/08/ad501382-9e48-4720-92c7-bcee5374671e_501f5f234304610bbbc221823de181e544c1bc09.cab" -OutFile ".\Bluetooth_Drivers.cab"
    Write-Host -ForegroundColor Green "Done"

    Write-Host -NoNewline "- MicroSD Card Reader Drivers from Windows Update: "
    Invoke-WebRequest -URI "https://catalog.s.download.windowsupdate.com/c/msdownload/update/driver/drvs/2022/10/4f20ec00-bee5-4df2-873c-3a49cf4d4f8b_0aaf931a756473e6f8be1ef890fb60c283e9e82e.cab" -OutFile ".\MicroSD_Drivers.cab"
    Write-Host -ForegroundColor Green "Done"

    Write-Host -NoNewline "- VC++ All in One Redistributable: "
    $download = Invoke-WebRequest -Uri "https://github.com/abbodi1406/vcredist/releases/download/v0.70.0/VisualCppRedist_AIO_x86_x64_70.zip"
    $download | Save-Download 
    Write-Host -ForegroundColor Green "Done"

    Write-Host -NoNewline "- DirectX Web Setup: "
    Invoke-WebRequest -URI "https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe"
    Write-Host -ForegroundColor Green "Done"

    Write-Host -NoNewline "- .NET 6.0 Setup: "
    $download = Invoke-WebRequest -Uri "https://download.visualstudio.microsoft.com/download/pr/38dca5f5-f10f-49fb-b07f-a42dd123ea30/335bb4811c9636b3a4687757f9234db9/dotnet-sdk-6.0.407-win-x64.exe"
    $download | Save-Download 
    Write-Host -ForegroundColor Green "Done"

    Write-Host -NoNewline "- ViGEmBus Setup: "
    $download = Invoke-WebRequest -Uri "https://github.com/ViGEm/ViGEmBus/releases/download/v1.21.442.0/ViGEmBus_1.21.442_x64_x86_arm64.exe"
    $download | Save-Download 
    Write-Host -ForegroundColor Green "Done"

    Write-Host -NoNewline "- RivaTuner Setup: "
    $download = Invoke-WebRequest -Uri "https://www.filecroco.com/download-file/download-rivatuner-statistics-server/14914/2360/"
    $download | Save-Download 
    Write-Host -ForegroundColor Green "Done"

    Write-Host -NoNewline "- SteamDeckTools: "
    $download = Invoke-WebRequest -Uri "https://github.com/ayufan/steam-deck-tools/releases/download/0.6.14/SteamDeckTools-0.6.14-portable.zip"
    $download | Save-Download 
    Write-Host -ForegroundColor Green "Done"

    Write-Host -NoNewline "- EqualizerAPO: "
    $download = Invoke-WebRequest -Uri "https://sourceforge.net/projects/equalizerapo/files/latest/download"
    $download | Save-Download 
    Write-Host -ForegroundColor Green "Done"

    Write-Host -NoNewline "- EqualizerAPO Config: "
    $download = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/CelesteHeartsong/SteamDeckAutomatedInstall/main/EqualizerAPO_Config.txt"
    $download | Save-Download     
    Write-Host -ForegroundColor Green "Done"

    Write-Host -NoNewline "- EqualizerAPO VST Plugin: "
    $download = Invoke-WebRequest -Uri "https://github.com/werman/noise-suppression-for-voice/releases/download/v1.03/win-rnnoise.zip"
    $download | Save-Download 
    Write-Host -ForegroundColor Green "Done"

    Write-Host "-----------------------------------------------------------------------"
    Write-Host
}

function disable-hibernation {
Write-Host -NoNewline "- Disabling Hibernation: "
Start-Process -FilePath "PowerCfg" -ArgumentList "/h /type reduced"
Write-Host -ForegroundColor Green "Done"
}

function Limit-fan-speed {
Write-Host -NoNewline "- Setting CPU Idle Min to 0% (Reduce fan speed): "
Start-Process -FilePath "PowerCfg" -ArgumentList "/SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 000" -Wait
Start-Process -FilePath "PowerCfg" -ArgumentList "/SETACTIVE SCHEME_CURRENT" -Wait
Write-Host -ForegroundColor Green "Done"

Write-Host -NoNewline "- Setting internal Clock to UTC: "
Start-Process -FilePath "reg" -ArgumentList "add `"HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation`" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f" -Wait
Write-Host -ForegroundColor Green "Done"

Write-Host -NoNewline "- Disable GameDVR: "
Start-Process -FilePath "reg" -ArgumentList "add `"HKEY_CURRENT_USER\System\GameConfigStore`" /f /v GameDVR_Enabled /t REG_DWORD /d 0" -Wait
Write-Host -ForegroundColor Green "Done"

Write-Host "-----------------------------------------------------------------------"
Write-Host
}


function install-drivers {
Write-Host "Installing Drivers (Don't reboot on APU install!)"
Write-Host "-----------------------------------------------------------------------"

Write-Host -NoNewline "- Installing APU Chipset: "
Start-Process ".\Aerith Windows Driver*\GFX Driver_*\Setup.exe" -Wait | Out-Null
$apicall::SystemParametersInfo(0x009F, 4294967295, $null, 1) | Out-Null
Write-Host -ForegroundColor Green "Done"

Write-Host -NoNewline "- Audio Drivers 1/2: "
Start-Process -FilePath "PNPUtil.exe" -ArgumentList "/add-driver `".\cs35l41-V*\cs35l41.inf`" /install" -Wait
Write-Host -ForegroundColor Green "Done"

Write-Host -NoNewline "- Audio Drivers 2/2: "
Start-Process -FilePath "PNPUtil.exe" -ArgumentList "/add-driver `".\NAU88L21_x64_*_WHQL - DUA_BIQ_WHQL\NAU88L21.inf`" /install" -Wait
Write-Host -ForegroundColor Green "Done"

Write-Host -NoNewline "- WLAN Drivers: "
New-Item .\WLAN_Drivers -ItemType Directory -ErrorAction SilentlyContinue >> $null
Start-Process -FilePath "expand.exe" -ArgumentList "-F:* .\WLAN_Drivers.cab .\WLAN_Drivers" -Wait
Start-Process -FilePath "PNPUtil.exe" -ArgumentList "/add-driver `".\WLAN_Drivers\netrtwlane.inf`" /install" -Wait
Write-Host -ForegroundColor Green "Done"

Write-Host -NoNewline "- Bluetooth Drivers: "
New-Item .\Bluetooth_Drivers -ItemType Directory -ErrorAction SilentlyContinue >> $null
Start-Process -FilePath "expand.exe" -ArgumentList "-F:* .\Bluetooth_Drivers.cab .\Bluetooth_Drivers" -Wait
Start-Process -FilePath "PNPUtil.exe" -ArgumentList "/add-driver `".\Bluetooth_Drivers\Rtkfilter.inf`" /install" -Wait
Write-Host -ForegroundColor Green "Done"

Write-Host -NoNewline "- MicroSD Drivers: "
New-Item .\MicroSD_Drivers -ItemType Directory -ErrorAction SilentlyContinue >> $null
Start-Process -FilePath "expand.exe" -ArgumentList "-F:* .\MicroSD_Drivers.cab .\MicroSD_Drivers" -Wait
Start-Process -FilePath "PNPUtil.exe" -ArgumentList "/add-driver `".\MicroSD_Drivers\bhtsddr.inf`" /install" -Wait
Write-Host -ForegroundColor Green "Done"

Write-Host "-----------------------------------------------------------------------"
Write-Host
}


function install-redistributables {
Write-Host "Installing Redistributables"
Write-Host "-----------------------------------------------------------------------"

Write-Host -NoNewline "- VC++ All in One: "
Expand-Archive ".\VisualCppRedist_AIO_x86_x64_*.zip" -DestinationPath ".\Vcpp" -Force
Start-Process .\Vcpp\VisualCppRedist_AIO_x86_x64.exe /ai -Wait
Write-Host -ForegroundColor Green "Done"

Write-Host -NoNewline "- DirectX Web Setup: "
Start-Process -FilePath ".\DirectX.exe" -ArgumentList "/Q" -Wait
Write-Host -ForegroundColor Green "Done"

Write-Host -NoNewline "- .NET 6.0: "
Start-Process -FilePath ".\dotnet-sdk-*-win-x64.exe" -ArgumentList "/quiet /norestart" -Wait
Write-Host -ForegroundColor Green "Done"

Write-Host "-----------------------------------------------------------------------"
Write-Host
}

#Write-Host "Installing Software (Select Speakers when requested then move to input tab, and select Microphone)"

function install-vigembus {
Write-Host -NoNewline "- ViGEmBus: "
Start-Process -FilePath ".\ViGEmBus_*.exe" -ArgumentList "/qn /norestart" -Wait
Write-Host -ForegroundColor Green "Done"
}

function install-deckutils {
Write-Host -NoNewline "- Create C:\DeckUtils: "
New-Item C:\DeckUtils -ItemType Directory -ErrorAction SilentlyContinue >> $null
Write-Host -ForegroundColor Green "Done"
}

function install-rivatuner {
Write-Host -NoNewline "- RivaTuner: "
Start-Process -FilePath ".\RTSSSetup*.exe" -ArgumentList "/S" -Wait
Write-Host -ForegroundColor Green "Done"
}

function install-steamdecktools {
Write-Host -NoNewline "- SteamDeckTools: "
Expand-Archive ".\SteamDeckTools*.zip" "C:\DeckUtils\SteamDeckTools" -Force
Write-Host -ForegroundColor Green "Done"
}

function install-equalizerapo {
Write-Host -NoNewline "- EqualizerAPO: "
Start-Process -FilePath ".\EqualizerAPO64-*.exe" -ArgumentList "/S" -Wait
Copy-Item ".\EqualizerAPO_Config.txt" -Destination "C:\Program Files\EqualizerAPO\config\config.txt" -Force
Write-Host -ForegroundColor Green "Done"

Write-Host -NoNewline "- EqualizerAPO Plugin: "
Expand-Archive ".\win-rnnoise.zip" -DestinationPath "C:\Program Files\EqualizerAPO\VSTPlugins\" -Force
Write-Host -ForegroundColor Green "Done"

Write-Host "-----------------------------------------------------------------------"
Write-Host
}

$trigger = New-ScheduledTaskTrigger -AtLogOn
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

function set-rivatuner-run-at-login {
Write-Host -NoNewline "- Setting RivaTuner to run on login: "
$action = New-ScheduledTaskAction -Execute "C:\Program Files (x86)\RivaTuner Statistics Server\RTSS.exe"
$description = "Start RivaTuner at Login"
Register-ScheduledTask -TaskName "RivaTuner" -Action $action -Trigger $trigger -RunLevel Highest -Description $description -Settings $settings >> $null
Write-Host -ForegroundColor Green "Done"
}

function deny-error-reporting-consent-steamdecktools {
    Write-Host -NoNewline "--- Disabling SteamDeckTools Error Reporting and Updater: "
    New-Item "C:\DeckUtils\SteamDeckTools\DisableCheckForUpdates.txt" >> $null
    New-Item "C:\DeckUtils\SteamDeckTools\DisableSentryTracking.txt" >> $null
    Write-Host -ForegroundColor Green "Done"
}

function set-fan-control-on-login {
Write-Host -NoNewline "- Setting FanControl to run on login: "
Start-Process -FilePath "C:\DeckUtils\SteamDeckTools\FanControl.exe" -ArgumentList "-run-on-startup"
Write-Host -ForegroundColor Green "Done"
}

function set-performanceoverlay-on-login {
Write-Host -NoNewline "- Setting PerformanceOverlay to run on login: "
Start-Process -FilePath "C:\DeckUtils\SteamDeckTools\PerformanceOverlay.exe" -ArgumentList "-run-on-startup"
Write-Host -ForegroundColor Green "Done"
}

function set-powercontrol-on-login {
Write-Host -NoNewline "- Setting PowerControl to run on login: "
Start-Process -FilePath "C:\DeckUtils\SteamDeckTools\PowerControl.exe" -ArgumentList "-run-on-startup"
Write-Host -ForegroundColor Green "Done"
}

function set-steam-controller-on-login {
Write-Host -NoNewline "- Setting SteamController to run on login: "
Start-Process -FilePath "C:\DeckUtils\SteamDeckTools\SteamController.exe" -ArgumentList "-run-on-startup"
Write-Host -ForegroundColor Green "Done"
}

function New-desktop-shortcut-for-steamdeck-tools {
Write-Host -NoNewline "- Creating Desktop Shortcuts for SteamDeckTools: "
$shell = New-Object -comObject WScript.Shell
$shortcut = $shell.CreateShortcut("$Home\Desktop\FanControl.lnk")
$shortcut.TargetPath = "C:\DeckUtils\SteamDeckTools\FanControl.exe"
$shortcut.Save()

$shell = New-Object -comObject WScript.Shell
$shortcut = $shell.CreateShortcut("$Home\Desktop\PerformanceOverlay.lnk")
$shortcut.TargetPath = "C:\DeckUtils\SteamDeckTools\PerformanceOverlay.exe"
$shortcut.Save()

$shell = New-Object -comObject WScript.Shell
$shortcut = $shell.CreateShortcut("$Home\Desktop\PowerControl.lnk")
$shortcut.TargetPath = "C:\DeckUtils\SteamDeckTools\PowerControl.exe"
$shortcut.Save()

$shell = New-Object -comObject WScript.Shell
$shortcut = $shell.CreateShortcut("$Home\Desktop\SteamController.lnk")
$shortcut.TargetPath = "C:\DeckUtils\SteamDeckTools\SteamController.exe"
$shortcut.Save()
}