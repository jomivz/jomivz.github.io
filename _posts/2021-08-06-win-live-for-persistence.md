---
layout: default
title: Windows Live Forensics on Persistence
parent: Forensics
category: Forensics
grand_parent: Cheatsheets
has_children: true
---

# {{ page.title}}

## [T1546.007](https://attack.mitre.org/techniques/T1546/007/) - Persistence via Netsh helper DLL

 - [How-To](https://pentestlab.blog/2019/10/29/persistence-netsh-helper-dll/) PoC this TTP with msfvenom and metasploit.
 - How-to investigate such abuse:
 
 ```
# method 1: using the powershell cmd Get-AuthenticationCodeSignature to check the code signature of the DLLs in 'HKLM\Software\Microsoft\Netsh'
powershell.exe -Command "(Get-ItemProperty hklm:\software\Microsoft\Netsh).psobject.properties.value -like '*.dll' | %{Get-AuthenticationCodeSignature $_}"

# method 2: if the DLL appears as 'notsigned' with the method 1, using sigcheck from sysinternals
for /F %i in ('powershell.exe -Command "(Get-ItemProperty hklm:\software\Microsoft\Netsh).psobject.properties.value -like '*.dll'"') do c:\Temp\sigcheck.exe /accepteula %i
```

## [T1546.007](https://attack.mitre.org/techniques/T1546/007/) - Persistence via svchost

- The process **svchost** loads services group via the **-k** parameter.
- Services group are listed in the registry key `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SVCHOST`.
- Services declared in the groups have an entry in `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services`.

 - How-to investigate such abuse for H-worm or Oudini RAT :

[H-worm](https://www.fireeye.com/blog/threat-research/2013/09/now-you-see-me-h-worm-by-houdini.html) uses a persistence like `C:\Windows\system32\svchost.exe -k LocalServiceNoNetwork` to run `C:\Windows\System32\wscript.exe" //B "C:\Users\JohnDoe\AppData\Local\Temp\139750_owned.vbs"`.

```
# method 1: 
for /F %i in ('powershell.exe -Command "(Get-ItemProperty 'hklm:\software\Microsoft\Windows NT\CurrentVersion\SVCHOST') | select -expandProperty LocalServiceNoNetwork"') do powershell.exe -Command "(Get-ItemProperty 'hklm:\system\CurrentControlSet\Services\Parameters\SErviceDLL') 
```






