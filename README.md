# bootstrap
scripts to bootstrap fresh windows install

# Instructions
1. Run powershell (`wt`) as admin and paste the following:
    ```ps1 
    Set-ExecutionPolicy RemoteSigned
    iex "& { $(iwr -useb https://raw.githubusercontent.com/Balfa/bootstrap/refs/heads/main/bootstrap.ps1) } -ComputerName Weggles -PackageLevel 'personal'"
    Set-ExecutionPolicy Restricted
    ```

# TODO
- Make it even more unattended. Single paste raw github file?
- Start migrating apps from choco to winget?
- Maybe split personal into gaming, dev, etc.?
- The rest of postinstallfirststeps...
- Test each change/install
- Validate idempotency
- Test uninstalling packages