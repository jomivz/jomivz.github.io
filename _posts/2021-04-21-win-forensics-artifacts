---
layout: default
title: Windows forensics Artifacts
parent: Forensics
categories: Forensics Windows
grand_parent: Cheatsheets
has_children: true
---

# {{ page.title}}
 
## Registry hives

- HKLM\SYSTEM : %SystemRoot%\system32\config\system
- HKLM\SAM :  %SystemRoot%\system32\config\sam
- HKLM\SECURITY :  %SystemRoot%\system32\config\security
- HKLM\SOFTWARE :  %SystemRoot%\system32\config\software
- HKLM\DEFAULT :  %SystemRoot%\system32\config\default
- HKCU\UserProfile :  %UserProfile%\NTuser.dat
- HKCU\Software\Classes : %UserProfile%\AppData\Local\Microsoft\Windows\UsrClass.dat

```powershell
# Listing the hives with powershell:
Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\hivelist\

# Browsing a hive with the interpreter
cd HKLM:
```

*References*
- [regripper repo]{https://github.com/keydet89/RegRipper3.0} : version 3.0
- [heaxacorn]{https://hexacorn.com/tools/3r.html} : listing/mapping of regripper plugins to hives

## Eventlogs Files

- %SystemRoot%\System32\winevt\logs\Application.evtx
- %SystemRoot%\System32\winevt\logs\Security.evtx
- %SystemRoot%\System32\winevt\logs\System.evtx
- %SystemRoot%\System32\winevt\logs\Windows Powershell.evtx
 

## NTFS metafiles

- Path: \\.\C:\[SYSTEM]
- Files: $MFT, $MFTMirr, $LogFile, $Volume, $AttrDef, . , $Bitmap, $Boot, $BadClus, $Secure, $UpCase, $Extend
- [https://en.wikipedia.org/wiki/NTFS#Metafiles]{} : descriptions table of the metaflies
