---
layout: default
title: Windows Live Forensics on Persistence
parent: Forensics
category: Forensics
grand_parent: Cheatsheets
has_children: true
---

# {{ page.title}}

## [T1547.001](https://attack.mitre.org/techniques/T1547/001/) - Persistence via Registry Run Keys / Start Up Folders

1- Dropping executables into Startup folders below.

| **Account**    | **Startup Folder**                                                                   |
|----------------|--------------------------------------------------------------------------------------|
| User           | `C:\Users\<username>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\` |
| Administrator  | `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup`                       |

2- Adding a registry subkey into the following keys.

| **Hive** | **Registry Run Keys**                                                       |
|----------|-----------------------------------------------------------------------------|
| HKCU     | HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run             |
| HKCU     | HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce         |
| HKCU     | HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServices     |
| HKCU     | HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce |
| HKLM     | HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run            |
| HKLM     | HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce        |
| HKLM     | HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServices    |
| HKLM     | HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce|

3- Adding a `Depend` registry subkey into `HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnceEx\*`

4- Adding a registry subkey into the following keys.

| **Hive** | **Shell Folder Registry keys**                                                           |
|----------|------------------------------------------------------------------------------------------|
| HKCU     | HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders  |
| HKCU     | HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders       |
| HKLM     | HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders      |
| HKLM     | HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders |

5- Start up folders declared into :

| **Hive** | **Start Up folders Keys**                                                          |
|----------|------------------------------------------------------------------------------------|
| HKCU     | HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run  |
| HKLM     | HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run |

6 - Winlogon

| **Hive** | **Winlogon Keys**                                                                  |
|----------|------------------------------------------------------------------------------------|
| HKCU     | HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows             |
| HKLM     | HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit  |
| HKLM     | HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell     |

7 - Boot Execute

- Adding an executable into the `BootExecute` value of the registry key `HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session`.
 

## [T1546.003](https://attack.mitre.org/techniques/T1546/003/) - Persistence via svchost

- [How-To](https://www.ired.team/offensive-security/persistence/persisting-in-svchost.exe-with-a-service-dll-servicemain) PoC this TTP by IRED.TEAM.
- The process **svchost** loads services group via the **-k** parameter.
- Services group are listed in the registry key `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SVCHOST`.
- Services declared in the groups have an entry in `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services`.

 - How-to investigate such abuse for H-worm or Oudini RAT :

[H-worm](https://www.fireeye.com/blog/threat-research/2013/09/now-you-see-me-h-worm-by-houdini.html) uses a persistence like `C:\Windows\system32\svchost.exe -k LocalServiceNoNetwork` to run `C:\Windows\System32\wscript.exe" //B "C:\Users\JohnDoe\AppData\Local\Temp\139750_owned.vbs"`.

```
# method 1: Listing the parameters of each service in the group in arg of svchost with -k option
for /F %i in ('powershell.exe -Command "(Get-ItemProperty 'hklm:\software\Microsoft\Windows NT\CurrentVersion\SVCHOST') | select -expandProperty LocalServiceNoNetwork"') do powershell.exe -Command "(Get-ItemProperty 'hklm:\system\CurrentControlSet\Services\%i')" 
```

To list exhaustively the scheduled tasks, run the cmd:
```
schtasks /query /fo LIST /v
```

## [T1546.007](https://attack.mitre.org/techniques/T1546/007/) - Persistence via Netsh helper DLL

 - [How-To](https://pentestlab.blog/2019/10/29/persistence-netsh-helper-dll/) PoC this TTP with msfvenom and metasploit.
 - How-to investigate such abuse:
 
 ```
# method 1: using the powershell cmd Get-AuthenticationCodeSignature to check the code signature of the DLLs in 'HKLM\Software\Microsoft\Netsh'
powershell.exe -Command "(Get-ItemProperty hklm:\software\Microsoft\Netsh).psobject.properties.value -like '*.dll' | %{Get-AuthenticationCodeSignature $_}"

# method 2: if the DLL appears as 'notsigned' with the method 1, using sigcheck from sysinternals
for /F %i in ('powershell.exe -Command "(Get-ItemProperty hklm:\software\Microsoft\Netsh).psobject.properties.value -like '*.dll'"') do c:\Temp\sigcheck.exe /accepteula %i
```
