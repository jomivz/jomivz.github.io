---
layout: post
title: dfir / win / artifacts
parent: cheatsheets
category: dfir
modified_date: 2024-06-17
permalink: /dfir/win
---

<!-- vscode-markdown-toc -->
* [amcache](#amcache)
* [autoruns](#autoruns)
* [dirs](#dirs)
	* [temp](#temp)
* [logs](#logs)
	* [logs-all](#logs-all)
	* [logs-dns](#logs-dns)
   	* [logs-ps](#logs-ps)
 	* [logs-svcs](#logs-svcs)
	* [logs-wmi](#logs-wmi)
* [mplogs](#mplogs)
* [ntfs](#ntfs)
	* [mft](#mft)
* [ntds-dit](#ntds-dit)
* [powershell-history](#powershell-history)
* [prefetch](#prefetch)
* [reg](#reg)
	* [regripper](#regripper)
	* [reg-history](#reg-history)
	* [reg-extra](#reg-extra)
* [shellbags](#shellbags)
* [shimcache](#shimcache)
* [web-browser](#web-browser)
* [wer](#wer)
	* [wer-persist](#wer-persist)
	* [lsass-shtinkering](#lsass-shtinkering)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

🔥 EXHAUSTIVE ARTIFACT LISTING: [dfir.tips](https://evids.dfir.tips) 🔥

## <a name='autoruns'></a>autoruns
```powershell
# https://github.com/davehull/Kansa/blob/master/Analysis/asep/Get-ASEPImagePathLaunchStringMD5UnsignedTimeStack.ps1
autorunsc.exe /accepteula -a * -c -h -s '*' -nobanner
.\Get-ASEPImagePathLaunchStringMD5UnsignedStack.ps1 > asep-workstation-stack.csv
```

## <a name='amcache'></a>amcache

Files in column of the table are in the directory `C:\Windows\AppCompat\Programs`.

![Amcache Artifacts](/assets/images/amcache_artifacts.PNG)

**Sources**
- ANSSI - [CoRIIN_2019 - Analysis AmCache](https://www.ssi.gouv.fr/uploads/2019/01/anssi-coriin_2019-analysis_amcache.pdf) - 07/2019
- ANSSI - [SANS DFIR AmCache Investigation](https://www.youtube.com/watch?v=_DqTBYeQ8yA) - 02/2020 

## <a name='dirs'></a>dirs

### <a name='temp'></a>temp
```powershell
# https://github.com/davehull/Kansa/blob/master/Modules/Disk/Get-TempDirListing.ps1
# source-code of 'Get-TempDirListing.ps1'
foreach($userpath in (Get-WmiObject win32_userprofile | Select-Object -ExpandProperty localpath)) {
    if (Test-Path(($userpath + "\AppData\Local\Temp\"))) {
        Get-ChildItem -Force ($userpath + "\AppData\Local\Temp\*") | Select-Object FullName, CreationTimeUtc, LastAccessTimeUtc, LastWriteTimeUtc
    }
}

# GUI visualization 
.\Get-TempDirListing.ps1 | Out-GridView
```

## <a name='logs'></a>logs

### <a name='logs-all'></a>logs-all

```powershell
# all Windows Versions

%SystemRoot%\System32\winevt\logs\Application.evtx
%SystemRoot%\System32\winevt\logs\Security.evtx
%SystemRoot%\System32\winevt\logs\System.evtx
%SystemRoot%\System32\winevt\logs\Windows Powershell.evtx

# https://github.com/davehull/Kansa/blob/master/Modules/Log/Get-LogWinEvent.ps1
.\Modules\Log\Get-LogWinEvent.ps1 security | Out-GridView
```

* Converting EVTX JSON or XML to CSV : [github.com/omerbenamram/EVTX](https://github.com/omerbenamram/evtx)

### <a name='logs-dns'></a>logs-dns 

1/ Are the DNS debug logs activated ?

```powershell
# open a console (`cmd.exe`) and run the command 
# to check the parameter `dwDebugLevel`. It value must be `00006101`.
dnscmd /Info
```

2/ Where are located the DNS debug logs ?

By default, the locations for storing DNS logs are :
```powershell
%SystemRoot%\System32\Winevt\Logs\Microsoft-Windows-DNSServer%4Analytical.etl
%SystemRoot%\System32\Dns\Dns.log
```

To verify it, open a console (`cmd.exe`) and run the commands:
```powershell
reg query HKLM\System\CurrentControlSet\Services\DNS\Parameters
Get-ChildItem -Path HKLM:\System\CurrentControlSet\Services\DNS
```

3/ How to activate the DNS logs ? How to define logs location ?

Open a console (`cmd.exe`) and run the commands:
```batch
# set the debug mode
dnscmd.exe localhost /Config /LogLevel 0x6101
# set the log file path
dnscmd.exe localhost /Config /LogFilePath "C:\Windows\System32\DNS\dns.log"
```

### <a name='logs-ps'></a>logs-ps
```powershell
```

### <a name='logs-svcs'></a>logs-svcs
```powershell
# https://github.com/davehull/Kansa/blob/master/Analysis/Get-LogparserStack.ps1
.\Get-LogparserStack.ps1 -FilePattern *SvcAll.csv -Delimiter "," -Direction asc -OutFile svcAll_stack.csv
# Answer these questions as follows:
# Enter the field to pass to COUNT(): Name
# Enter the fields you want to GROUP BY, one per line. Enter "quit" when finished: Name
# Enter the fields you want to GROUP BY, one per line. Enter "quit" when finished: DisplayName
# Enter the fields you want to GROUP BY, one per line. Enter "quit" when finished: PathName
# Enter the fields you want to GROUP BY, one per line. Enter "quit" when finished: quit
```

### <a name='logs-svcs'></a>logs-wmi
```powershell
# OPTION 1 : https://github.com/davehull/Kansa/blob/master/Modules/Process/Get-ProcsWMI.ps1
.\Modules\Process\Get-ProcsWMI.ps1 | Out-GridView

# OPTION 2 : https://github.com/davehull/Kansa/blob/master/Analysis/Get-LogparserStack.ps1
.\Get-LogparserStack.ps1 -FilePattern *WmiEvtFilter.csv -Delimiter "," -Direction asc -OutFile wmiEvtFilter_stack.csv
# Answer these questions as follows:
# Enter the field to pass to COUNT(): Name
# Enter the fields you want to GROUP BY, one per line. Enter "quit" when finished: Name
# Enter the fields you want to GROUP BY, one per line. Enter "quit" when finished: Query
# Enter the fields you want to GROUP BY, one per line. Enter "quit" when finished: quit
```

## <a name='mplogs'></a>mplogs
```poweshell

```

## <a name='ntfs'></a>ntfs

NTFS metafiles : 

- Path: \\.\C:\[SYSTEM]
- Files: $MFT, $MFTMirr, $LogFile, $Volume, $AttrDef, . , $Bitmap, $Boot, $BadClus, $Secure, $UpCase, $Extend
- [https://en.wikipedia.org/wiki/NTFS#Metafiles]() : descriptions table of the metaflies

### <a name='amcache'></a>mft
```powershell
# kape collection
Set-ExecutionPolicy –ExecutionPolicy Unrestricted
$command = "C:\kape\kape.exe"
$params = "--tsource C:\ --tdest C:\kape\output --tflush --target FileSystem --zip kapeoutput" 
Start-Process -FilePath $command -ArgumentList $params –Wait

# convert the artifacts to CSV for timeline explorer
cd C:\kape\Modules\bin
MFTECmd.exe -f $MFT --csv C:\Windows\Temp --csvf mft.csv
MFTECmd.exe -f $Extend\$J --csv C:\Windows\Temp --csvf usrjrnl.csv
```

## <a name='ntds-dit'></a>ntds-dit

```powershell
# file present on DCs
ls %SystemRoot%\NTDS\Ntds.dit
```

## <a name='powershell-history'></a>powershell-history
```
# https://learn.microsoft.com/en-us/powershell/module/psreadline/set-psreadlineoption?view=powershell-7.4&viewFallbackFrom=powershell-6
Get-PSReadLineOption

# path
$env:APPDATA\Roaming\Microsoft\Windows\PowerShell\PSReadLine\$($Host.Name)_history.txt

# enable / disable history
Set-PSReadlineOption -HistorySaveStyle SaveNothing
```

## <a name='prefetch'></a>prefetch

**Keypoints:**
* artifact to prioritize for collection as it can be overwritten during DFIR execs
* existence of prefetch does not mean the successful execution
* digits in the filename stands for the PE path hash
* multiple prefetch for the same PE, can mean different locations (different PE path hash)
* exception: PE path hash for 'svchost', 'dllhost', 'backgroundtaskhost', 'rundll32' take into account the 'path + command-line'    

```batch
# prefetch caching enable/disabled in the SYSTEM registry
dir "HKLM:/SYSTEM/CurrentControlSet/Control/Session Manager/Memory Management"
# value: PrefetchParameters
# type REG_DWORD
# 0 = Disabled
# 1 = Application launch prefetching enabled
# 2 = Boot prefetching enabled
# 3 = Application launch and boot enabled

# one shot
pecmd -f E:\C\Windows\prefetch\XXX.EXE-12345678.pf

# timeline V01
pecmd -d C:\Windows\prefetch -q --csvf dc01_prefetch.csv --csv f:\case_01

# timeline V02
pecmd -d C:\Windows\prefetch -k "svchost, dllhost, backgroundtaskhost, rundll32"
```

## <a name='reg'></a>reg

**Keypoints:**
* There is 1 'NTUSER.DAT' and 1 'UsrClass.dat' / USER

| **Hive** | **System Path** |
|---------------|-------------|
| HKLM\SYSTEM | %SystemRoot%\system32\config\system |
| HKLM\SAM | %SystemRoot%\system32\config\sam |
| HKLM\SECURITY | %SystemRoot%\system32\config\security |
| HKLM\SOFTWARE | %SystemRoot%\system32\config\software |
| HKLM\DEFAULT | %SystemRoot%\system32\config\default |
| HKCU\UserProfile | %UserProfile%\NTuser.dat |
| HKCU\Software\Classes | %UserProfile%\AppData\Local\Microsoft\Windows\UsrClass.dat |

* [retrieve the transaction logs | andrafortunea | python](https://andreafortuna.org/2021/02/06/windows-registry-transaction-logs-in-forensic-analysis/)
* [registry transaction logs | goocle cloud](https://cloud.google.com/blog/topics/threat-intelligence/digging-up-the-past-windows-registry-forensics-revisited/?hl=en)

### <a name='regripper'></a>regripper

* credits: [hexacorn](https://hexacorn.com/tools/3r.html)

* Confirming the asset & timezone:

| **Hive** | **Plugin** |
|---------------|-------------|
| system | compname |
| system | timezone |

* Interesting findings:

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

| **Tactic** |  **Hive**  | **RegRipper Plugin** | **Powershell Live** 	|
|------------|------------|----------------------|-------------------------|
| INIT       | system     | usbstore 	         | dir HKLM:\SYSTEM\ControlSet001\Enum\USBSTOR |
| INIT       |            | 		         | dir "HKCU:\Software\Microsoft\Internet Explorer\TypedURLs*", dir "HKCU:\Software\Microsoft\Internet Explorer\Download*" 		        |
| LAT MOV    | ntuser.dat | rdphint 	         | 			|
| PERSIST    | ntuser.dat | startup 	         | (ProfilePath)\Start Menu\Programs\Startup |
| PERSIST    | ntuser.dat | autoruns             | dir HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows\Run*, dir HKCU:\Software\Microsoft\Windows\CurrentVersion\Run*, dir HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce* 	                                                        |
| PERSIST    | XXX        | autoruns             | dir HKLM:\Software\Microsoft\Windows\CurrentVersion\Runonce*, dir HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\Explorer\Run*, dir HKLM:\Software\Microsoft\Windows\CurrentVersion\Run* 		                                        |
| PERSIST    | software   | run 		 | dir "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search\JumpList*" 			|
| EXEC       | ntuser.dat | officedocs           | 			|
| EXEC       | ntuser.dat | officedocs2010       | 			|
| EXEC       | ntuser.dat | recentdocs           | 			|
| EXEC       | ntuser.dat | run  		 | dir HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU*, dir HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist* |
| 	     | usrclass.dat | clsid              | 			|
| EXEC       | usrclass.dat | cmd_shell_u        | 			|
|            | software | clsid                  | 			|
| EXEC       | software | cmd_shell  	         | 			|
|            | software | dcom 		         | 			|
|            | software | inprocserver 	         | 			|
| EXEC       | system   | prefetch 	         | 			|
|            | all      | sizes 		 | 			|
|            |          |                        | dir HKLM:\SYSTEM\ControlSet001\Services\Tcpip\Parameters\Interfaces\*                                                           |

### <a name='reg-history'></a>reg-history 

* credits: [fireeye](https://www.fireeye.com/blog/threat-research/2019/01/digging-up-the-past-windows-registry-forensics-revisited.html)

**What is it ?** System and registry hives can be tampered to hide compromise / make the forensics harder. The table below lists the evidences to figure out if anti-forensics happened.

| **Evidence Type** | **User hives** | **System hives** |
|-------------------------------------|-------------------------------------|-------------------------------------|
| Registry transaction logs (.LOG)    | %UserProfile% <br /> %UserProfile%\AppData\Local\Microsoft\Windows | %SystemRoot%\system32\config\ | 
| Transactional registry transaction logs (.TxR) | %UserProfile% <br /> %UserProfile%\AppData\Local\Microsoft\Windows | %SystemRoot%\System32\config\TxR |
| Deleted entries in registry hives   | unallocated cells                                                        ||
| Backup system hives (REGBACK)       | %SystemRoot%\System32\config\RegBack                                     ||
| Hives backed up with System Restore | \\\\.\\\"System Volume Information"                                      ||

### <a name='reg-extra'></a>reg-extra

* Extra: Live collection of a locked hive :

```batch
# useful when having remote access but system handle do not allow read/copy/download 
# batch: registry hive live collection
reg save HKLM\SYSTEM system.reg
```

* Extra: live browsing a hive in CLI :
```powershell
# powershell: listing the registry hives
Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\hivelist\

# powershell: browsing a hive with the interpreter
cd HKLM:
```

## <a name='shellbags'></a>shellbags

```powershell
# 
USRCLASS.DAT\Local Settings\Software\Microsoft\Windows\Shell\Bags
USRCLASS.DAT\Local Settings\Software\Microsoft\Windows\Shell\BagMRU
NTUSER.DAT\Software\Microsoft\Windows\Shell\BagMRU
NTUSER.DAT\Software\Microsoft\Windows\Shell\Bags
```

## <a name='shimcache'></a>shimcache


**Keypoints:**
* subsystem allowing a program to invoke properties of different OS versions
* compatibility modes are called "shims"
* data buffered in memory / committed in registry on shutdown and reboot
* app is shimmed if rewritten, renamed, moved
* existence of InsertFlag does not mean the successful execution (OS behavior variation)
* 1 SDB / ControlSet 

```
# parse all currentcontrolset
appcompatcacheparser -f C:\Windows\system32\config\SYSTEM --csv g:\execution --csvf appcompatcache.csv

# check the CurrentControlSet
dir HKLM:SYSTEM
```

**Sources:**
* [windows controlset](https://www.malekal.com/comprendre-hkey-local-machine-system-currentcontrol/)  

## <a name='web-browser'></a>web-browser

| Browser    | OS         | Path                                                               |
|------------|------------|--------------------------------------------------------------------|
| Brave      | Windows    | %AppDataM\Local\Brave\User Data\Default |
| Edge       | Windows    | %userprofile%\AppData\Local\Microsoft\Edge\User Data\Default |
| Chrome     | Windows XP | %userprofile%\Local Settings\Application Data\Google\Chrome\User Data\Default |
| Chrome     | Windows 10 | %userprofile%\AppData\Local\Google\Chrome\User Data\Default |
| Chrome     | Linux      | /home/%username%/.config/google-chrome/Default |
| Chrome     | Mac OS X   | /Users/<username>/Library/Application Support/Google/Chrome/Default |
| Chrome     | iOS        | \Applications\com.google.chrome.ios\Library\Application Support\Google\Chrome\Default |
| Chrome     | Android    | /userdata/data/com.android.chrome/app_chrome/Default |
| Mozilla    | Windows    | %APPDATA%\Mozilla\Firefox\Profiles\\ <ProfileName>\ |
| Mozilla    | Linux      | ~/.mozilla/firefox/<ProfileName> |
| Mozilla    | Mac OS X   | ~/Library/Application Support/Firefox/Profiles/<ProfileName> |
| Vivaldi    | Windows    | %AppDataM\Local\Vivaldi\User Data\Default |

**Sources:**
- [firefox profiles](https://support.mozilla.org/fr/kb/profils-la-ou-firefox-conserve-donnees-utilisateur?redirectslug=Profils+utilisateurs)

## <a name='wer'></a>wer
### <a name='wer-persist'></a>wer-persist
```powershell
# 2024-02-12 / Persistence / POC
# https://github.com/0xHossam/WERPersistence/tree/main
C:\ProgramData\Microsoft\Windows\WER\ReportQueue\*.wer

# 2023-01-04 / Execution / pupy RAT / DLL side-loading / APT33 
# https://www.bleepingcomputer.com/news/security/hackers-abuse-windows-error-reporting-tool-to-deploy-malware/
werfault.dll
```

### lsass-shtinkering

**Keypoints:**
* Artifact / Event Log
	* Event ID 1000 is generated under “Windows Logs\Application”
 	* Event doesn’t specify the sender process
  * Artifact / Dump File:
  	* Dump files will be written to %LocalAppData%\CrashDumps
   	* For processes running as “NT AUTHORITY\SYSTEM”, the path is:
```
C:\Windows\system32\config\systemprofile\AppData\Local\CrashDumps
```

**Sources**
-[DEFCON 30 - lsass shtinkering | talk](https://www.youtube.com/watch?v=-QRr_8pvOiY))
-[DEFCON 30 - lsass shtinkering | slides](https://infocon.org/cons/DEF%20CON/DEF%20CON%2030/DEF%20CON%2030%20presentations/Asaf%20Gilboa%20-%20LSASS%20Shtinkering%20Abusing%20Windows%20Error%20Reporting%20to%20Dump%20LSASS.pdf)
