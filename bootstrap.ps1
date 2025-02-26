param (
    [string]$ComputerName,
    [string]$PackageLevel
)

. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
iex "& { $(iwr -useb https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/mehhacking/regfixes.ps1) } -ComputerName $ComputerName"

switch ($PackageLevel) {
    "administered" {
        # just for family member PCs etc.
        Install-BoxstarterPackage -DisableReboots -PackageName https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/mehhacking/boxstarter-administered-appliances.txt
    }
    "personal" {
        # for any of my personal PCs other than my primary desktop
        Install-BoxstarterPackage -DisableReboots -PackageName https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/mehhacking/boxstarter-administered-appliances.txt
        Install-BoxstarterPackage -DisableReboots -PackageName https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/mehhacking/boxstarter-personal.txt
    }
    "hardware-specific" {
        # for my primary desktop (SteelSeries Engine, etc.)
        Install-BoxstarterPackage -DisableReboots -PackageName https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/mehhacking/boxstarter-administered-appliances.txt
        Install-BoxstarterPackage -DisableReboots -PackageName https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/mehhacking/boxstarter-personal.txt
        Install-BoxstarterPackage -DisableReboots -PackageName https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/mehhacking/boxstarter-hardware-specific.txt
    }
    default {
        Write-Error "Invalid PackageLevel specified. Use 'administered', 'personal', or 'hardware-specific'."
    }
}