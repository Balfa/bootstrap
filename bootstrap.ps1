Set-ExecutionPolicy RemoteSigned
. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
Install-BoxstarterPackage -DisableReboots -PackageName https://gist.githubusercontent.com/Balfa/9fb4e630d6c735fbbd9b080c2c7a831e/raw/boxstarter-regfixes.ps1
Install-BoxstarterPackage -DisableReboots -PackageName https://gist.githubusercontent.com/Balfa/d39406f11e067aca19104783ed5e45aa/raw/boxstarter-p.txt
Install-BoxstarterPackage -DisableReboots -PackageName https://gist.githubusercontent.com/Balfa/d39406f11e067aca19104783ed5e45aa/raw/z-boxstarter-hardware-specific.txt
