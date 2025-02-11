Set-ExecutionPolicy RemoteSigned
. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
. { iwr -useb https://git.githubusercontent.com/Balfa/bootstrap/raw/regfixes.ps1 } | iex;
Install-BoxstarterPackage -DisableReboots -PackageName https://gist.githubusercontent.com/Balfa/d39406f11e067aca19104783ed5e45aa/raw/boxstarter-p.txt
# Install-BoxstarterPackage -DisableReboots -PackageName https://gist.githubusercontent.com/Balfa/d39406f11e067aca19104783ed5e45aa/raw/z-boxstarter-hardware-specific.txt
