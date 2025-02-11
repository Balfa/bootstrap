Set-ExecutionPolicy RemoteSigned
. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
iex "& { $(iwr -useb https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/mehhacking/regfixes.ps1) } -ComputerName Weggles"
Install-BoxstarterPackage -DisableReboots -PackageName https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/mehhacking/boxstarter-administered-appliances.txt
# Stop here if this install is just for family member PCs etc.
Install-BoxstarterPackage -DisableReboots -PackageName https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/mehhacking/boxstarter-personal.txt
# Stop here if it's for any of my personal PCs other than my primary desktop
# Install-BoxstarterPackage -DisableReboots -PackageName https://gist.githubusercontent.com/Balfa/d39406f11e067aca19104783ed5e45aa/raw/z-boxstarter-hardware-specific.txt
Set-ExecutionPolicy Restricted
