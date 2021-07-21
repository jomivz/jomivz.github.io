---
layout: default
title: Windows forensics Artifacts
parent: Forensics
categories: Forensics Windows
grand_parent: Cheatsheets
has_children: true
---

# {{ page.title}}
 
## Amcache

### *Files / Evidences*

![Amcache Artifacts](/assets/images/amcache_artifacts.png)

```
C:\Windows\AppCompat\Programs\Amcache.hve
C:\Windows\AppCompat\Programs\Amcache.hve.LOGS
```

**References**
- ANSSI - [CoRIIN_2019 - Analysis AmCache](https://www.ssi.gouv.fr/uploads/2019/01/anssi-coriin_2019-analysis_amcache.pdf) - 07/2019
- ANSSI - [SANS DFIR AmCache Investigation](https://www.youtube.com/watch?v=_DqTBYeQ8yA) - 02/2020 

## Registry hives

### *Files / Evidences*

**What is it ?** Files listed are the evidences to collect for the forensics. 

**Note:** There is one NTuser.dat and one UsrClass.dat per user to collect.

| **Hive** | **System Path** |
|---------------|-------------|
| HKLM\SYSTEM | %SystemRoot%\system32\config\system |
| HKLM\SAM | %SystemRoot%\system32\config\sam |
| HKLM\SECURITY | %SystemRoot%\system32\config\security |
| HKLM\SOFTWARE | %SystemRoot%\system32\config\software |
| HKLM\DEFAULT | %SystemRoot%\system32\config\default |
| HKCU\UserProfile | %UserProfile%\NTuser.dat |
| HKCU\Software\Classes | %UserProfile%\AppData\Local\Microsoft\Windows\UsrClass.dat |

### *Forensics with RegRipper (credits: [heaxacorn](https://hexacorn.com/tools/3r.html))*

#### Confirming the asset & timezone

| **Hive** | **Plugin** |
|---------------|-------------|
| system | compname |
| system | timezone |

#### Interesting findings

**What is it ?** In a forensics, the table below tend to help identify interesting [regripper](https://github.com/keydet89/RegRipper3.0) plugins to run on which evidences.

**Note:** refer to [heaxacorn](https://hexacorn.com/tools/3r.html) for the full listing/mapping of regripper plugins to hives.

**Note:** Run the plugins for ntuser.dat and userclass.dat, as many as the number of evidences (two per users) collected.
```bash
# Onliner to unarchive all ntuser_<username>.dat.zip collected to ntuser_<username>.dat
for i in `ls ntuser_*.dat.zip`; do unzip $i > `echo $i | sed 's/\.[^.]*$//'`; done 

# Loop example to run the autoruns plugins on all ntuser.dat, here renamed to ntuser_<username>.dat when collected
for i in `ls ntuser_*.dat`; do regripper -r $i -p autoruns; done

# Loop example to run the clsid plugins on all usrclass.dat, here renamed to usrclass_<username>.dat when collected
for i in `ls usrclass_*.dat`; do regripper -r $i -p clsid; done
```

| **Hive** | **Interesting Plugin** |
|---------------|-------------|
| ntuser.dat | autoruns |
| ntuser.dat | officedocs |
| ntuser.dat | officedocs2010 |
| ntuser.dat | rdphint |
| ntuser.dat | recentdocs |
| ntuser.dat | run |
| ntuser.dat | startup |
| usrclass.dat | clsid |
| usrclass.dat | cmd_shell_u |
| software | clsid |
| software | cmd_shell |
| software | dcom |
| software | inprocserver |
| software | run |
| system | prefetch |
| system | usbstore |
| all | sizes |

### *Registry history data (credits: [fireeye](https://www.fireeye.com/blog/threat-research/2019/01/digging-up-the-past-windows-registry-forensics-revisited.html))*

**What is it ?** System and registry hives can be tampered to hide compromise / make the forensics harder. The table below lists the evidences to figure out if anti-forensics happened.

| **Evidence Type** | **User hives** | **System hives** |
|-------------------------------------|-------------------------------------|-------------------------------------|
| Registry transaction logs (.LOG)    | %UserProfile% <br /> %UserProfile%\AppData\Local\Microsoft\Windows | %SystemRoot%\system32\config\ | 
| Transactional registry transaction logs (.TxR) | %UserProfile% <br /> %UserProfile%\AppData\Local\Microsoft\Windows | %SystemRoot%\System32\config\TxR |
| Deleted entries in registry hives   | unallocated cells                                                        ||
| Backup system hives (REGBACK)       | %SystemRoot%\System32\config\RegBack                                     ||
| Hives backed up with System Restore | \\\\.\\\"System Volume Information"                                      ||

### *Extra: Live collection of a locked hive*
```batch
# useful when having remote access but system handle do not allow read/copy/download 
# batch: registry hive live collection
reg save HKLM\SYSTEM system.reg
```

### *Extra: live browsing a hive in CLI*
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
