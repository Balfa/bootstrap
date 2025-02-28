param (
    [string]$ComputerName,
    [string]$PackageLevel
)

# Validate PackageLevel
if ($PackageLevel -notin @("administered", "personal", "hardware-specific")) {
    throw "Invalid PackageLevel specified. Use 'administered', 'personal', or 'hardware-specific'."
}

. { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; Get-Boxstarter -Force
Invoke-Expression "& { $(Invoke-WebRequest -useb https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/main/regfixes.ps1) } -ComputerName $ComputerName"

# Define package URLs
$administeredPackage = "https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/main/boxstarter-administered-appliances.txt"
$personalPackage = "https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/main/boxstarter-personal.txt"
$hardwareSpecificPackage = "https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/main/boxstarter-hardware-specific.txt"

# Always install the administered package
Install-BoxstarterPackage -DisableReboots -PackageName $administeredPackage

# Install personal package for 'personal' or 'hardware-specific' levels
if ($PackageLevel -in @("personal", "hardware-specific")) {
    Install-BoxstarterPackage -DisableReboots -PackageName $personalPackage
    # dotfiles (bash, git...)
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Balfa/dotfiles/main/install.sh" -UseBasicParsing | Select-Object -ExpandProperty Content | & "C:\Program Files\Git\bin\bash.exe"
    ## to test...
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Balfa/flumpus/main/test_gitconfig.sh" -UseBasicParsing | Select-Object -ExpandProperty Content | & "C:\Program Files\Git\bin\bash.exe"
    # Install my Sublime timestamp script
    Invoke-WebRequest -Uri "https://gist.githubusercontent.com/Balfa/e56e6c1fffcb8609828ab637942dbaa7/raw/install.sh" -UseBasicParsing | Select-Object -ExpandProperty Content | & "C:\Program Files\Git\bin\bash.exe"
    # Add "Open With Sublime Text" to context menu (with icon!!)
    Invoke-WebRequest -Uri "https://gist.githubusercontent.com/Balfa/3a7e049dc1ac2d8ae1441a6e4e7c3f37/raw/OpenWithSublimeText.bat" -UseBasicParsing | Select-Object -ExpandProperty Content | & cmd
}

# Install hardware-specific package only for 'hardware-specific' level
if ($PackageLevel -eq "hardware-specific") {
    Install-BoxstarterPackage -DisableReboots -PackageName $hardwareSpecificPackage
    # Install RDP Pass To Local
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Balfa/RdpPassToLocal/main/install.cmd" -UseBasicParsing | Select-Object -ExpandProperty Content | & cmd
    # And add soundswitch to startup
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Balfa/RdpPassToLocal/main/add-soundswitch-to-startup.cmd" -UseBasicParsing | Select-Object -ExpandProperty Content | & cmd
}
