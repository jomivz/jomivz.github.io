---
layout: post
title:  Sysadmin WIN Powershell - Useful queries
category: Sysadmin
parent: Sysadmin
grand_parent: Cheatsheets
modified_date: 2022-08-29
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* 1. [PSCredential initialization](#PSCredentialinitialization)
* 2. [PSSession & Invoke-Command](#PSSessionInvoke-Command)
* 3. [SMB File sharing](#SMBFilesharing)
* 4. [CRUD in Registry Keys](#CRUDinRegistryKeys)
* 5. [CRUD MAC addresses](#CRUDMACaddresses)
* 6. [Search for Hotfix](#SearchforHotfix)
* 7. [Search in ActiveDirectory](#SearchinActiveDirectory)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='PSCredentialinitialization'></a>PSCredential initialization
```powershell
$zdom = "contoso"
$zlat_user = "john_doe"
$zlat_pass = "PASSWORD" | ConvertTo-SecureString -AsPlainText -Force
$zlat_login = $zdom + "\" + $zlat_user
$zlat_creds = New-Object System.Management.Automation.PSCredential($zlat_login,$zlat_pass)
```

##  2. <a name='PSSessionInvoke-Command'></a>PSSession & Invoke-Command 

!!! Verify [WinRM is running](/sysadmin/sys-win-cli/#activatePSRemoting) !!!

```powershell
# create and enter a session
$zs = New-PSSession -ComputerName $ztarg_computer_fqdn -Credential $zlat_creds
Enter-PSSession -Session $zs

# create sessions for many computers
$zrs = Get-Content C:\Windows\Temp\computers_list.txt | New-PSSession -ThrottleLimit 50
Get-PSSession
Enter-PSSession -id 3

# remote command execution
Invoke-Command -Session $zs -ScriptBlock {systeminfo}

# clean the current session
Exit-PsSession

# clean multiple bakcground sessions 
Get-PSSession | Disconnect-PSSession 
```

##  3. <a name='SMBFilesharing'></a>SMB File sharing
```powershell

# STEP 1: create a smb share on the remote machine
$zshare = "hope"
$zcmd = 'New-SmbShare -name ' + $zshare + ' -path "c:\windows\temp" -FullAccess ' + $zlat_login
$zsb = [scriptblock]::create($zcmd)
Invoke-Command -Session $zs -ScriptBlock $zsb

# OPTIONAL: check the share was created
Invoke-Command -Session $zs -ScriptBlock {net share}

# STEP 2.1: download a file to C:\windows\temp
$zfile = 'test.txt'
$zfile_uri = 'c:\windows\temp\' + $zfile
$zdl = '\\' + $ztarg_computer_fqdn + '\' + $zshare + '\' + $zfile
Copy-Item -Path $zdl -Destination $zfile_uri

# STEP 2.2: upload a file
$zfile = 'test.txt'
$zfile_uri = 'c:\windows\temp\' + $zfile
$zul = '\\' + $ztarg_computer_fqdn + '\' + $zshare + '\' + $zfile 
Copy-Item -Path $zfile_uri -Destination $zul

# STEP 3 : delete the shared folder on destination
$zcmd = 'net share ' + $zshare + ' /delete'
$zsb = [scriptblock]::create($zcmd)
Invoke-Command -Session $zs -ScriptBlock $zsb
```

##  4. <a name='CRUDinRegistryKeys'></a>CRUD in Registry Keys 
```powershell
#? Listing registry hives
get-psdrive -PSProvider registry

Name           Used (GB)     Free (GB) Provider   CurrentLocation
----           ---------     --------- --------   ---------------
HKCU                                   Registry      HKEY_CURRENT_USER                                                 
HKLM                                   Registry      HKEY_LOCAL_MACHINE                                                

#? Get registry key
Get-ChildItem REGISTRY::HKEY_USERS | select name

Name                                                                                                    ----                                                                                                           
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
```
##  5. <a name='CRUDMACaddresses'></a>CRUD MAC addresses
```powershell
#? Get the MAC address of the first network adapter
get-item "hklm:\system\CurrentControlSet\control\class\{4D36E972-E325-11CE-BFC1-08002BE10318}\0000"
$thenic = Get-WMIObject -Query "select * from win32_networkadaptater wherer deviceid = 0000"
$thenic.macaddress

#? Disable the network adapter
$thenic.disable()

#? Enable the network adapter
$thenic.enable()

#? Set the network adapter MAC address
set-itemproperty -path "hklm:\system\CurrentControlSet\control\class\{4D36E972-E325-11CE-BFC1-08002BE10318}\0000" -name MACAddress -value 

```
 
##  6. <a name='SearchforHotfix'></a>Search for Hotfix 
```powershell
#? Listing registry hives
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

##  7. <a name='SearchinActiveDirectory'></a>Search in ActiveDirectory

For Offensive AD enumeration, refer to ()[]. 

```powershell
#? Installing telnet clients 	
Import-module servermanager
  Add-windowsfeature telnet-client

#? ActiveDirectory module mandatory for the following commands
Import-module ActiveDirectory

#? Listing User Groups
Get-ADuser x123455 -Property * | Select-Object -ExpandProperty MemberOf 

#? Listing Group Members
Get-ADGroup EMEA-PXY-Web-ReadWrite -Property * | Select-Object -ExpandProperty Member 

#? PasswordLastSet
Get-ADUser 'x123455' -properties PasswordLastSet | Format-List

#? Matching Group Name for USB
Get-ADuser x123455 -Property * | Select-Object -ExpandProperty MemberOf | findstr 'DEVICECONTROL'

#? Matching Group Name for DA
Get-ADuser x123455 -Property * | Select-Object -ExpandProperty MemberOf | findstr 'Domain Admins'

#? Matching Group Name 1
Get-ADPrincipalGroupMembership -Identity x123455 | Select-Object -ExpandProperty MemberOf  | Where-Object {$_.name -like '*DEVICECONTROL*' } 		

#? Listing Computer Info
Get-ADComputer -Filter {Name -Like "dell-xps*"} -Property * | Format-Table Name,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion -Wrap -Auto

#? Listing Win > 5.1
Get-ADComputer -Filter {OperatingSystemVersion -ge "5.1"} -Property * | Format-Table Name,OperatingSystem,OperatingSystemVersion -Wrap -Auto
```