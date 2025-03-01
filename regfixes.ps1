# boxstarter-regfixes.ps1 
# This is a ps script I can call to fix some windows configs for things, and remove all sorts of crud bloatware

# To run (in powershell):
#########################
# Set-ExecutionPolicy RemoteSigned
# . { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
# Install-BoxstarterPackage -DisableReboots -PackageName https://gist.githubusercontent.com/Balfa/9fb4e630d6c735fbbd9b080c2c7a831e/raw/boxstarter-regfixes.ps1
# Set-ExecutionPolicy Restricted

# Currently called directly by bootstrap.ps1

param (
    [Parameter(Mandatory=$true)]
    [string]$ComputerName
)


# These ones are from https://gist.github.com/Balfa/a4915062eca10857c017465858029733
# Show all tray icons
Function ShowTrayIcons {
    Write-Host "Showing all tray icons..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 0
}
# Hide Taskbar Search button / box
Function HideTaskbarSearchBox {
    Write-Host "Hiding Taskbar Search box / button..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
}
# Hide Task View button
Function HideTaskView {
    Write-Host "Hiding Task View button..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
}
# Unpin all Taskbar icons - Note: This function has no counterpart. You have to pin the icons back manually.
Function UnpinTaskbarIcons {
    Write-Host "Unpinning all Taskbar icons..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites" -Type Binary -Value ([byte[]](0xFF))
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "FavoritesResolve" -ErrorAction SilentlyContinue
}
# Disable OneDrive
Function DisableOneDrive {
    Write-Host "Disabling OneDrive..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1
}
# Hide 3D Objects icon from This PC - The icon remains in personal folders and open/save dialogs
Function Hide3DObjectsFromThisPC {
    Write-Host "Hiding 3D Objects icon from This PC..."
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
}
# Hide 3D Objects icon from Explorer namespace - Hides the icon also from personal folders and open/save dialogs
Function Hide3DObjectsFromExplorer {
    Write-Host "Hiding 3D Objects icon from Explorer namespace..."
    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    If (!(Test-Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag")) {
        New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}
# Hide Pictures icon from Explorer namespace - Hides the icon also from personal folders and open/save dialogs
Function HidePicturesFromExplorer {
    Write-Host "Hiding Pictures icon from Explorer namespace..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}
# Hide Videos icon from Explorer namespace - Hides the icon also from personal folders and open/save dialogs
Function HideVideosFromExplorer {
    Write-Host "Hiding Videos icon from Explorer namespace..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}
# Hide Music icon from This PC - The icon remains in personal folders and open/save dialogs
Function HideMusicFromThisPC {
    Write-Host "Hiding Music icon from This PC..."
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" -Recurse -ErrorAction SilentlyContinue
}
# Hide Music icon from Explorer namespace - Hides the icon also from personal folders and open/save dialogs
Function HideMusicFromExplorer {
    Write-Host "Hiding Music icon from Explorer namespace..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}
# Show small icons in taskbar
Function ShowSmallTaskbarIcons {
    Write-Host "Showing small icons in taskbar..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Type DWord -Value 1
}
# Unpin all Start Menu tiles - Not applicable to Server - Note: This function has no counterpart. You have to pin the tiles back manually.
Function UnpinStartMenuTiles {
    Write-Host "Unpinning all Start Menu tiles..."
    Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" -Include "*.group" -Recurse | ForEach-Object {
        $data = (Get-ItemProperty -Path "$($_.PsPath)\Current" -Name "Data").Data -Join ","
        $data = $data.Substring(0, $data.IndexOf(",0,202,30") + 9) + ",0,202,80,0,0"
        Set-ItemProperty -Path "$($_.PsPath)\Current" -Name "Data" -Type Binary -Value $data.Split(",")
    }
}

# These ones are my own creations
Function HideCortanaButton {
    Write-Host "Hiding Taskbar Cortana button..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0
}
Function AppsUseDarkTheme {
    Write-Host "Enabling Dark Theme..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Type DWord -Value 0
}
Function HideTaskbarOnSecondMonitor {
    Write-Host "Hiding Taskbar on second monitor..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarEnabled" -Type DWord -Value 0
}
Function SetExplorerDefaultLocationToMyComputer {
    Write-Host "Setting My Computer as default location for Explorer..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
}
Function FixRdpUdpBug {
    Write-Host "Fixing RDP UDP bug..."
    # reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client" /v fClientDisableUDP /d 1 /t REG_DWORD
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client" -Name "fClientDisableUDP" -Type DWord -Value 1
}
Function RenameComputer {
    param (
        [string]$NewName
    )

    if (-not $NewName) {
        Write-Host "Error: No computer name provided."
        return
    }

    Write-Host "Renaming computer to $NewName..."
    Rename-Computer -NewName $NewName -Force -PassThru
}
Function FixMissingGameBarError {
    # From https://www.reddit.com/r/WindowsHelp/comments/108ngxr/properly_uninstalling_xbox_gamebar_and_resolve/
    Write-Host "Fixing Missing Game Bar Error...?"
    reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR /f /t REG_DWORD /v "AppCaptureEnabled" /d 0
    reg add HKEY_CURRENT_USER\System\GameConfigStore /f /t REG_DWORD /v "GameDVR_Enabled" /d 0
}
Function BypassWindows11ContextMenu {
    # restores old explorer context menu in windows 11 (instead of daft "Show more options" thing)
    # Converted by ChatGPT (https://chatgpt.com/c/67c20d40-f3f4-8007-932a-220504ab656d) from `reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve`
    # Which came originally from https://www.reddit.com/r/microsoft/comments/sv88tb/how_to_remove_show_more_options_from_windows_11/hxepvbb/
    Write-Host "Restoring old pre-Windows 11 explorer context menu..."
    $regPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name "(default)" -Value "" -Force
}


ShowTrayIcons
HideTaskbarSearchBox
HideTaskView
UnpinTaskbarIcons
DisableOneDrive
Hide3DObjectsFromThisPC
Hide3DObjectsFromExplorer
HidePicturesFromExplorer 
HideVideosFromExplorer
HideMusicFromThisPC
HideMusicFromExplorer
ShowSmallTaskbarIcons
UnpinStartMenuTiles

HideCortanaButton
AppsUseDarkTheme
HideTaskbarOnSecondMonitor
SetExplorerDefaultLocationToMyComputer
FixRdpUdpBug
FixMissingGameBarError
BypassWindows11ContextMenu
RenameComputer -NewName "$ComputerName"


# Remove Windows preinstalled crap # This has to happen before boxtarter. At least the preloaded version of Spotify does
Get-AppxPackage *3dbuilder* | Remove-AppxPackage
# Get-AppxPackage *windowsalarms* | Remove-AppxPackage # try out not removing this?
# Get-AppxPackage *windowscalculator* | Remove-AppxPackage # oh god srsly?
Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage
# Get-AppxPackage *windowscamera* | Remove-AppxPackage # try out not removing this?
Get-AppxPackage *officehub* | Remove-AppxPackage
Get-AppxPackage *skypeapp* | Remove-AppxPackage
Get-AppxPackage *getstarted* | Remove-AppxPackage
Get-AppxPackage *zunemusic* | Remove-AppxPackage
Get-AppxPackage *windowsmaps* | Remove-AppxPackage
Get-AppxPackage *solitairecollection* | Remove-AppxPackage
Get-AppxPackage *bingfinance* | Remove-AppxPackage
Get-AppxPackage *zunevideo* | Remove-AppxPackage
Get-AppxPackage *bingnews* | Remove-AppxPackage
Get-AppxPackage *onenote* | Remove-AppxPackage
# Get-AppxPackage *people* | Remove-AppxPackage # Seems to cause errors trying to remove this on latest win 11?
Get-AppxPackage *windowsphone* | Remove-AppxPackage
# Get-AppxPackage *photos* | Remove-AppxPackage # try out not removing this?
# Get-AppxPackage *windowsstore* | Remove-AppxPackage # oh god maybe not this one? I already uninstalled it this time, but I might need it? 
Get-AppxPackage *bingsports* | Remove-AppxPackage
# Get-AppxPackage *soundrecorder* | Remove-AppxPackage # try out not removing this?
Get-AppxPackage *bingweather* | Remove-AppxPackage
Get-AppxPackage *xboxapp* | Remove-AppxPackage


# Here are some more that I figured out myself and hopefully they didn't break everything
Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage
Get-AppxPackage Microsoft.WebMediaExtensions | Remove-AppxPackage
Get-AppxPackage Microsoft.WebpImageExtension | Remove-AppxPackage
# Get-AppxPackage Microsoft.MSPaint | Remove-AppxPackage # try out not removing this?
Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxIdentityProvider | Remove-AppxPackage
Get-AppxPackage Microsoft.Wallet | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxSpeechToTextOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxGameOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.Xbox.TCUI | Remove-AppxPackage
Get-AppxPackage Microsoft.YourPhone | Remove-AppxPackage
Get-AppxPackage Microsoft.MixedReality.Portal | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftStickyNotes | Remove-AppxPackage
# Get-AppxPackage Microsoft.MicrosoftEdge.Stable | Remove-AppxPackage
Get-AppxPackage SpotifyAB.SpotifyMusic | Remove-AppxPackage