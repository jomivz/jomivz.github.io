---
layout: post
title:  Sysadmin WIN CLI powershell
category: sys
parent: cheatsheets
modified_date: 2023-06-08
permalink: /sys/powershell
---

<!-- vscode-markdown-toc -->
* [pscredential](#pscredential)
* [pssession](#pssession)
* [transfer-smb](#transfer-smb)
* [transfer-http](#transfer-http)
* [transfer-ftp](#transfer-ftp)
* [crud-reg](#crud-reg)
* [crud-mac](#crud-mac)
* [get-hotfix](#get-hotfix)
* [get-aduser](#get-aduser)
* [get-adgroup](#get-adgroup)
* [get-adcomputer](#get-adcomputer)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='pscredential'></a>pscredential
PSCredential initialization:
```powershell
$zdom = "contoso"
$ztarg_user_name = "john_doe"
$ztarg_user_pass = "PASSWORD" | ConvertTo-SecureString -AsPlainText -Force
$ztarg_login = $zdom + "\" + $zlat_user
$ztarg_creds = New-Object System.Management.Automation.PSCredential($ztarg_user_login,$ztarg_user_pass)
```

## <a name='pssession'></a>pssession

!!! Verify [WinRM is running](/sysadmin/sys-win-cli/#activatePSRemoting) !!!

```powershell
# create and enter a session
$zs = New-PSSession -ComputerName $ztarg_computer_fqdn -Credential $ztarg_creds
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

## <a name='transfer-smb'></a>transfer-smb
```powershell

# STEP 1: create a smb share on the remote machine
$zshare = "hope"
$zcmd = 'New-SmbShare -name ' + $zshare + ' -path "c:\windows\temp" -FullAccess ' + $ztarg_login
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

[Yesterday 1:41 PM] MICHEL-VILLAZ Jonathan 

## <a name='transfer-http'></a>transfer-http
```
Invoke-RestMethod -Uri $uri -Method Post -InFile $uploadPath -UseDefaultCredentials
$wc = New-Object System.Net.WebClient
$resp = $wc.UploadFile($uri,$uploadPath)
```

## <a name='transfer-ftp'></a>transfer-ftp

* [transfer-ftp](https://www.howtogeek.com/devops/how-to-upload-files-over-ftp-with-powershell/)

## <a name='crud-reg'></a>crud-reg 
```powershell
#? Listing registry hives
get-psdrive -PSProvider registry

Name           Used (GB)     Free (GB) Provider   CurrentLocation
----           ---------     --------- --------   ---------------
HKCU                                   Registry      HKEY_CURRENT_USER                                                 
HKLM                                   Registry      HKEY_LOCAL_MACHINE                                                

#? Get registry key
Get-ChildItem REGISTRY::HKEY_USERS | select name

Name                                                                                                    ----                                                                                                    HKEY_USERS\.DEFAULT  
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

## <a name='crud-mac'></a>crud-mac
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
 
## <a name='get-hotfix'></a>get-hotfix 
```powershell
#? Listing registry hives
Get-ChildItem "REGISTRY::HKEY_USERS\S-2-5-21-X-1125\Software\Microsoft\Windows\CurrentVersion\Devices" -Recurse-ErrorAction SilentlyContinue

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

## <a name='get-aduser'></a>get-aduser
```powershell
#? Installing telnet clients 	
Import-module servermanager
  Add-windowsfeature telnet-client

#? ActiveDirectory module mandatory for the following commands
Import-module ActiveDirectory

#? Listing User Groups
Get-ADuser $ztarg_user_name -Property * | Select-Object -ExpandProperty MemberOf 

#? PasswordLastSet
Get-ADUser $ztarg_user_name -properties PasswordLastSet | Format-List

#? Matching Group Name for USB
Get-ADuser $ztarg_user_name -Property * | Select-Object -ExpandProperty MemberOf | findstr 'DEVICECONTROL'

#? Matching Group Name for DA
Get-ADuser $ztarg_user_name -Property * | Select-Object -ExpandProperty MemberOf | findstr 'Domain Admins'
```

## <a name='get-adgroup'></a>get-adgroup
```powershell
#? Matching Group Name 1
Get-ADPrincipalGroupMembership -Identity $ztarg_user_name | Select-Object -ExpandProperty MemberOf  | Where-Object {$_.name -like '*DEVICECONTROL*' } 		

Get-ADGroup EMEA-PXY-Web-ReadWrite -Property * | Select-Object -ExpandProperty Member 
```

## <a name='get-adcomputer'></a>get-adcomputer
```powershell
# Listing Computer Info
Get-ADComputer -Filter {Name -Like "dell-xps*"} -Property * | Format-Table Name,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion -Wrap -Auto

# Listing Win > 5.1
Get-ADComputer -Filter {OperatingSystemVersion -ge "5.1"} -Property * | Format-Table Name,OperatingSystem,OperatingSystemVersion -Wrap -Auto
```