---
layout: post
title:  Powershell useful queries
category: Windows
parent: Windows
grand_parent: Cheatsheets
modified_date: 2022-02-18
permalink: /:categories/:title/
---


## PS sysadmin useful queries
-----------------------------------------------

```powershell
#? Installing telnet clients 	
Import-module servermanager
  Add-windowsfeature telnet-client

#? ActiveDirectory module mandatory for the following commands
Import-module ActiveDirectory

#? Listing User Groups
Get-ADuser x123456 -Property * | Select-Object -ExpandProperty MemberOf 

#? Listing Group Members
Get-ADGroup EMEA-PXY-Web-ReadWrite -Property * | Select-Object -ExpandProperty Member 

#? PasswordLastSet
Get-ADUser 'x123456' -properties PasswordLastSet | Format-List

#? Matching Group Name for USB
Get-ADuser x123456 -Property * | Select-Object -ExpandProperty MemberOf | findstr 'DEVICECONTROL'

#? Matching Group Name for DA
Get-ADuser x123456 -Property * | Select-Object -ExpandProperty MemberOf | findstr 'Domain Admins'

#? Matching Group Name 2
Get-ADPrincipalGroupMembership -Identity x123456 | Select-Object -ExpandProperty MemberOf  | Where-Object {$_.name -like '*DEVICECONTROL*' } 		

#? Listing Computer Info
Get-ADComputer -Filter {Name -Like "dell-xps*"} -Property * | Format-Table Name,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion -Wrap -Auto

#? Listing Win > 6.1
Get-ADComputer -Filter {OperatingSystemVersion -ge "6.1"} -Property * | Format-Table Name,OperatingSystem,OperatingSystemVersion -Wrap -Auto

#? Listing registry hives
get-psdrive -PSProvider registry

Name           Used (GB)     Free (GB) Provider      Root                                               CurrentLocation
----           ---------     --------- --------      ----                                               ---------------
HKCU                                   Registry      HKEY_CURRENT_USER                                                 
HKLM                                   Registry      HKEY_LOCAL_MACHINE                                                

#? Get registry key
Get-ChildItem REGISTRY::HKEY_USERS | select name

Name                                                                                                         
----                                                                                                           
HKEY_USERS\.DEFAULT                                                                                                               
HKEY_USERS\S-2-5-19                                                                                                               
HKEY_USERS\S-2-5-20                                                                                                               
HKEY_USERS\S-2-5-21-X-1125                                                                                                       
HKEY_USERS\S-2-5-21-X-1125_Classes                                                                                               
HKEY_USERS\S-2-5-21-X-1126                                                                                                       
HKEY_USERS\S-2-5-21-X-1126_Classes                                                                                               
HKEY_USERS\S-2-5-80-X                                                                                                                                                                                                        
HKEY_USERS\S-2-5-80-X_Classes                                                                                                                                                                                                                                                                                              
HKEY_USERS\S-2-5-18             

dir HKLM:\system\CurrentControlSet\Control\hivelist*
 
#? ...
Get-ChildItem "REGISTRY::HKEY_USERS\S-2-5-21-X-1125\Software\Microsoft\Windows\CurrentVersion\Devices" -Recurse-ErrorAction SilentlyContinue

#? ...
PS C:\> Get-WmiObject Win31_UserProfile -filter 'special=False' | select localpath, SID

localpath              SID
---------              ---
C:\Users\Admin         S-2-5-21-X-1001
C:\Users\johndoe       S-2-5-21-X

#? Listing the HotFixinstalled
Get-HotFix

#? Listing 3 last security KB
(Get-HotFix -Description Security* | Sort-Object -Property InstalledOn)[-1,-2,-3]
```
