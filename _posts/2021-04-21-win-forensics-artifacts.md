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

*Files*

Evidences to collect for the forensics. 

Note: There is one NTuser.dat and one UsrClass.dat per user to collect.

| **Hive** | **System Path** |
|---------------|-------------|
| HKLM\SYSTEM | %SystemRoot%\system32\config\system |
| HKLM\SAM | %SystemRoot%\system32\config\sam |
| HKLM\SECURITY | %SystemRoot%\system32\config\security |
| HKLM\SOFTWARE | %SystemRoot%\system32\config\software |
| HKLM\DEFAULT | %SystemRoot%\system32\config\default |
| HKCU\UserProfile | %UserProfile%\NTuser.dat |
| HKCU\Software\Classes | %UserProfile%\AppData\Local\Microsoft\Windows\UsrClass.dat |

*[Forensics with RegRipper (credits: heaxacorn)](https://hexacorn.com/tools/3r.html)*

Forensics comrpomise in registry hives.

Note: refer to [heaxacorn](https://hexacorn.com/tools/3r.html) for the full listing/mapping of regripper plugins to hives.

| **Hive** | **Interesting Plugin** |
|---------------|-------------|
| ntuser.dat | autoruns |
| ntuser.dat | startup |
| ntuser.dat | rdphint |
| ntuser.dat | recentdocs |
| ntuser.dat | officedocs |
| ntuser.dat | officedocs2010 |
| ntuser.dat | run |
| usrclass.dat | cmd_shell_u |
| usrclass.dat | clsid |
| software | cmd_shell |
| software | run |
| software | clsid |
| software | inprocserver |
| software | dcom |
| system | usbstore |
| all | sizes |

*[Registry history data (credits: fireeye)](https://www.fireeye.com/blog/threat-research/2019/01/digging-up-the-past-windows-registry-forensics-revisited.html)*

Forensics anti-forensics in registry hives.

| **Evidence Type** | **User hives** | **System hives** |
|-------------------------------------|-------------------------------------|-------------------------------------|
| Registry transaction logs (.LOG)    | %UserProfile% <br /> %UserProfile%\AppData\Local\Microsoft\Windows | %SystemRoot%\system32\config\ | 
| Transactional registry transaction logs (.TxR) | %UserProfile% <br /> %UserProfile%\AppData\Local\Microsoft\Windows | %SystemRoot%\System32\config\TxR |
| Deleted entries in registry hives   | unallocated cells                                                        ||
| Backup system hives (REGBACK)       | %SystemRoot%\System32\config\RegBack                                     ||
| Hives backed up with System Restore | \\\\.\\\"System Volume Information"                                      ||

*Extra: Live collection*
```batch
# useful when having remote access but system handle do not allow read/copy/download 
# batch: registry hive live collection
reg save HKLM\SYSTEM system.reg
```

*Extra: Live CLI reading*
```powershell
# powershell: listing the registry hives
Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\hivelist\

# powershell: browsing a hive with the interpreter
cd HKLM:
```

## Eventlogs Files

- %SystemRoot%\System32\winevt\logs\Application.evtx
- %SystemRoot%\System32\winevt\logs\Security.evtx
- %SystemRoot%\System32\winevt\logs\System.evtx
- %SystemRoot%\System32\winevt\logs\Windows Powershell.evtx
 

## NTFS metafiles

- Path: \\.\C:\[SYSTEM]
- Files: $MFT, $MFTMirr, $LogFile, $Volume, $AttrDef, . , $Bitmap, $Boot, $BadClus, $Secure, $UpCase, $Extend
- [https://en.wikipedia.org/wiki/NTFS#Metafiles]() : descriptions table of the metaflies
