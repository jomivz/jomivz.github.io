---
layout: post
title:  dfir / win /live
category: sys
parent: cheatsheets
modified_date: 2024-01-26
permalink: /dfir/win/live
---

<!-- vscode-markdown-toc -->

* [execution-via-svchost](#execution-via-svchost)
* [uncommon-dll-paths](#uncommon-dll-paths)
* [dll-behind-clsid-InprocServer32](#dll-behind-clsid-InprocServer32)
* [infection-usb-andromeda](#infection-usb-andromeda)
* [infection-webshell-coldfusion](#infection-webshell-coldfusion)
* [mark-of-the-web](#mark-of-the-web)
* [code-signing-cert-cloning](#code-signing-cert-cloning)
* [powershell-history-file](#powershell-history-file)

## services

### system-with-manual-start
```powershell
# https://medium.com/r3d-buck3t/abuse-service-registry-acls-windows-privesc-f88079140509
# 01 # enum of services permissions
Get-Acl -Path hklm:\System\CurrentControlSet\services\ | format-list
$acl = get-acl HKLM:\SYSTEM\CurrentControlSet\Services
ConvertFrom-SddlString -Sddl $acl.Sddl | Foreach-Object {$_.DiscretionaryAcl}

# 02 # enum of services with SYSTEM permissions AND manual start
$services = Get-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\*
$services | Where-Object {($_.ObjectName -eq "LocalSystem") -and ($_.Start -eq 3)} | select {$_.PSPath}
$services | Where-Object {($_.ObjectName -eq "LocalSystem") -and ($_.Start -eq 3)} | select {$_.ImagePath}
$services | Where-Object {($_.ObjectName -eq "LocalSystem") -and ($_.Start -eq 3)} | select {$_.DisplayName}

# 03 # enum of the X service' properties
$h = Get-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\wuauserv
$h['PSPath']
$h['ImagePath']
$h['DisplayName']
```

### execution-via-svchost
```powershell
# The process **svchost** loads services group via the **-k** parameter.
# Services group are listed in the registry key `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SVCHOST`.
# Services declared in the groups have an entry in `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services`.
# list out  with cmd.exe
for /F %i in ('powershell.exe -Command "(Get-ItemProperty 'hklm:\software\Microsoft\Windows NT\CurrentVersion\SVCHOST') | select -expandProperty LocalServiceNoNetwork"') do powershell.exe -Command "(Get-ItemProperty 'hklm:\system\CurrentControlSet\Services\%i')"
# powershell list out
foreach ($i in (Get-ItemProperty 'hklm:\software\Microsoft\Windows NT\CurrentVersion\SVCHOST' | select -expandProperty LocalServiceNoNetwork)) { (Get-ItemProperty hklm:\system\CurrentControlSet\Services\$i).Description } 
```

## uncommon-dll-paths
```powershell
# list out ServiceDLL value for all system services
# look for DLLs that are loaded from suspicious locations (i.e non c:\windows\system32)
# https://www.ired.team/offensive-security/persistence/persisting-in-svchost.exe-with-a-service-dll-servicemain
Get-ItemProperty hklm:\SYSTEM\ControlSet001\Services\*\Parameters | ? { $_.servicedll } | select psparentpath, servicedll
```

## dll-behind-clsid-InprocServer32
```powershell
# return the DLL behind a CLSID (PS object)
get-item "HKCU:\SOFTWARE\Classes\CLSID\*"
get-itemproperty "HKLM:\SOFTWARE\Classes\CLSID\{FFFDC614-B694-4AE6-AB38-5D6374584B52}\InprocServer32"

# special CLSID => 3AD05575-8857-4850-9277-11B85BDB8E09 => UAC bypass => TTP "COM surrogate" => write DLL in 'system32'
reg query hkey_classes_root\clsid\{3AD05575-8857-4850-9277-11B85BDB8E09}
```
- [DLL hijack of CFF](https://www.ired.team/offensive-security/privilege-escalation/t1038-dll-hijacking#observations)
- [COM Surrogate IFileOperation](https://www.elastic.co/security-labs/exploring-windows-uac-bypasses-techniques-and-detection-strategies)

## <a name='get-adcomputer'></a>infection-usb-andromeda
```powershell
# 01 - Listing hidden folder using a NBSP character as name, aka Andromeda USB infections
# https://www.crowdstrike.com/blog/how-to-remediate-hidden-malware-real-time-response/
Get-ChildItem -LiteralPath E:\$([char]0xA0)\ -Force

# 02 - Remediation, cleaning the USB drive
Remove-Item -Path ''E:\SAMSUNG (2GB).lnk -Force
Remove-Item -LiteralPath E:\$([char]0xA0)\__--__-_--_-_--__--__ -Force
Remove-Item -LiteralPath E:\$([char]0xA0)\desktop.ini -Force
Remove-Item -LiteralPath E:\$([char]0xA0)\IndexerVolumeGuid -Force

# 03 - User files recovery
Get-ChildItem -LiteralPath E:\$([char]0xA0)\ -Force -Recurse | Move-Item -Destination E:\

# 04 - Removing the hidden folder
Remove-Item -LiteralPath E:\$([char]0xA0)\ -Force
```

## <a name='get-adcomputer'></a>infection-webshell-coldfusion
```powershell
# child above 160 characters
grep -R -e "*.cfm" /var/log/*.
```

## <a name='get-adcomputer'></a>mark-of-the-web
```powershell
# https://outflank.nl/blog/2020/03/30/mark-of-the-web-from-a-red-teams-perspective/
$files = Get-Item $env:userprofile/Downloads/m* 
Foreach ($file in $files) {$file; Get-Content –Stream Zone.Identifier $file; echo "`n"} 
```

## code-signing-certificate-cloning
```powershell
# attack 'code signing certificate cloning': https://posts.specterops.io/code-signing-certificate-cloning-attacks-and-defenses-6f98657fc6ec
# defense: registry keys for installation https://gist.github.com/mattifestation/75d6117707bcf8c26845b3cbb6ad2b6b#file-rootcainstallationdetection-xml
# defense: check registry key creation with 'TargetObject property ends with "<THUMBPRINT_VALUE>\Blob"'
Get-AuthenticodeSignature -FilePath C:\Test\HelloWorld.exe

# check that certificate
Get-ChildItem -Path Cert:\ -Recurse | Where-Object { $_.Thumbprint -eq '1F3D38F280635F275BE92B87CF83E40E40458400' } | Format-List *
```

 ## powershell-history-file
```powershell
%userprofile%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt
Get-Content (Get-PSReadlineOption).HistorySavePath | more
``` 
