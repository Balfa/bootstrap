param (
    [string]$ComputerName,
    [string]$PackageLevel
)

. { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; Get-Boxstarter -Force
Invoke-Expression "& { $(Invoke-WebRequest -useb https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/main/regfixes.ps1) } -ComputerName $ComputerName"

# Define package URLs
$administeredPackage = "https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/main/boxstarter-administered-appliances.txt"
$personalPackage = "https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/main/boxstarter-personal.txt"
$hardwareSpecificPackage = "https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/main/boxstarter-hardware-specific.txt"

# Validate PackageLevel
if ($PackageLevel -notin @("administered", "personal", "hardware-specific")) {
    Write-Error "Invalid PackageLevel specified. Use 'administered', 'personal', or 'hardware-specific'."
    exit 1
}

# Always install the administered package
Install-BoxstarterPackage -DisableReboots -PackageName $administeredPackage

# Install personal package for 'personal' or 'hardware-specific' levels
if ($PackageLevel -in @("personal", "hardware-specific")) {
    Install-BoxstarterPackage -DisableReboots -PackageName $personalPackage
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Balfa/dotfiles/main/install.sh" -UseBasicParsing | Select-Object -ExpandProperty Content | & "C:\Program Files\Git\bin\bash.exe"

}

# Install hardware-specific package only for 'hardware-specific' level
if ($PackageLevel -eq "hardware-specific") {
    Install-BoxstarterPackage -DisableReboots -PackageName $hardwareSpecificPackage
}
