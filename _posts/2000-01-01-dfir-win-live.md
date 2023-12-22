---
layout: post
title:  dfir / win /live
category: sys
parent: cheatsheets
modified_date: 2023-12-05
permalink: /dfir/win/live
---

<!-- vscode-markdown-toc -->
* [infection-usb-andromeda](#infection-usb-andromeda)
* [infection-webshell-coldfusion](#infection-webshell-coldfusion)
* [mark-of-the-web](#mark-of-the-web)
* [code-signing-cert-cloning](#code-signing-cert-cloning)

## get-clsid-exec-rundll32
```powershell
get-item "HKCU:\SOFTWARE\Classes\CLSID\*"
get-item "HKLM:\SOFTWARE\Classes\CLSID\*"
```

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

## <a name='get-adcomputer'></a>code-signing-cert-cloning
```powershell
``` 
