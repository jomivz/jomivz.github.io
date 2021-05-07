---
layout: default
title: Localhost Powershell Queries 
parent: Forensics
categories: Forensics Windows
grand_parent: Cheatsheets
has_children: true
---

# {{ page.title}}
 
```powershell
PS C:\> get-psdrive -PSProvider registry

Name           Used (GB)     Free (GB) Provider      Root                                               CurrentLocation
----           ---------     --------- --------      ----                                               ---------------
HKCU                                   Registry      HKEY_CURRENT_USER                                                 
HKLM                                   Registry      HKEY_LOCAL_MACHINE                                                


PS C:\> Get-ChildItem REGISTRY::HKEY_USERS | select name

Name                                                                                                         
----                                                                                                           
HKEY_USERS\.DEFAULT                                                                                                               
HKEY_USERS\S-1-5-19                                                                                                               
HKEY_USERS\S-1-5-20                                                                                                               
HKEY_USERS\S-1-5-21-X-1125                                                                                                       
HKEY_USERS\S-1-5-21-X-1125_Classes                                                                                               
HKEY_USERS\S-1-5-21-X-1126                                                                                                       
HKEY_USERS\S-1-5-21-X-1126_Classes                                                                                               
HKEY_USERS\S-1-5-80-X                                                                                                                                                                                                        
HKEY_USERS\S-1-5-80-X_Classes                                                                                                                                                                                                                                                                                              
HKEY_USERS\S-1-5-18             

dir HKLM:\system\CurrentControlSet\Control\hivelist*

Get-ChildItem "REGISTRY::HKEY_USERS\S-1-5-21-X-1125\Software\Microsoft\Windows\CurrentVersion\Devices" -Recurse-ErrorAction SilentlyContinue

PS C:\> Get-WmiObject Win32_UserProfile -filter 'special=False' | select localpath, SID

localpath              SID
---------              ---
C:\Users\Admin         S-1-5-21-X-1001
C:\Users\johndoe       S-1-5-21-X

```
