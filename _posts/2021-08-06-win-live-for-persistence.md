---
layout: default
title: Windows Live Forensics on Persistence
parent: Forensics
category: Forensics
grand_parent: Cheatsheets
has_children: true
---

# {{ page.title}}

[TA0003](https://attack.mitre.org/tactics/TA0003) 

## CLI full-report with [autorunsc](https://docs.microsoft.com/en-us/sysinternals/downloads/autoruns)

Sysinternals autorunsc (CLI version of autoruns) covers a lot of TTPs (24/04/2021). 

Supports options to focus on dedicated tecniques. 
Autorunsc can also be used (computing the hashes and/or querying VT).
For a CSV full-report, run it as below : 
```
# method 1: compute hashes
autorunsc /accepteula -a t -c -s -h > autorunsct.csv

# method 2: query virustotal
autorunsc /accepteula -a t -c -s -h -v -vt -u > autorunscvtt.csv
```

Also you can consult the [Mitre Autoruns List](https://attack.mitre.org/techniques/T1547/001/).
```powershell
# example: removal of the autorun for houdini RAT
powershell -command "get-item 'hklm:\software\microsoft\Windows\CurrentVersion\Run' | Select-Object -ExpandProperty Property"
´╗┐RtHDVCpl
RtHDVBg_PushButton
WavesSvc
Windows Mobile Device Center
139750_owned
reg delete hklm\software\microsoft\Windows\CurrentVersion\Run /v 139750_owned
```

## [T1543.003](https://attack.mitre.org/techniques/T1543/003/) - Persistence via svchost

- [How-To](https://www.ired.team/offensive-security/persistence/persisting-in-svchost.exe-with-a-service-dll-servicemain) PoC this TTP by IRED.TEAM.
- The process **svchost** loads services group via the **-k** parameter.
- Services group are listed in the registry key `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SVCHOST`.
- Services declared in the groups have an entry in `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services`.

1/ How-to investigate such abuse:

```
# method 1: Listing the parameters of each service in the group in arg of svchost with -k option
for /F %i in ('powershell.exe -Command "(Get-ItemProperty 'hklm:\software\Microsoft\Windows NT\CurrentVersion\SVCHOST') | select -expandProperty LocalServiceNoNetwork"') do powershell.exe -Command "(Get-ItemProperty 'hklm:\system\CurrentControlSet\Services\%i')" 
```

2/ To list exhaustively the scheduled tasks, run the cmd:
```
schtasks /query /fo LIST /v
```

## [T1546.007](https://attack.mitre.org/techniques/T1546/007/) - Persistence via Netsh helper DLL

 - [How-To](https://pentestlab.blog/2019/10/29/persistence-netsh-helper-dll/) PoC this TTP with msfvenom and metasploit.
 
 1/ How-to investigate such abuse:
 
 ```
# method 1: using the powershell cmd Get-AuthenticationCodeSignature to check the code signature of the DLLs in 'HKLM\Software\Microsoft\Netsh'
powershell.exe -Command "(Get-ItemProperty hklm:\software\Microsoft\Netsh).psobject.properties.value -like '*.dll' | %{Get-AuthenticationCodeSignature $_}"

# method 2: if the DLL appears as 'notsigned' with the method 1, using sigcheck from sysinternals
for /F %i in ('powershell.exe -Command "(Get-ItemProperty hklm:\software\Microsoft\Netsh).psobject.properties.value -like '*.dll'"') do c:\Temp\sigcheck.exe /accepteula %i
```
