param (
    [string]$ComputerName,
    [string]$PackageLevel
)

. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
iex "& { $(iwr -useb https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/main/regfixes.ps1) } -ComputerName $ComputerName"

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
}

# Install hardware-specific package only for 'hardware-specific' level
if ($PackageLevel -eq "hardware-specific") {
    Install-BoxstarterPackage -DisableReboots -PackageName $hardwareSpecificPackage
}
