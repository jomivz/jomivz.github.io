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
	* [[T1003.006](https://attack.mitre.org/techniques/T1003/006) DCSYNC](#T1003.006https:attack.mitre.orgtechniquesT1003006DCSYNC)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

### <a name='T1003.006https:attack.mitre.orgtechniquesT1003006DCSYNC'></a>[T1003.006](https://attack.mitre.org/techniques/T1003/006) DCSYNC
```powershell
# AllExtendedRights privilege grants both the DS-Replication-Get-Changes and DS-Replication-Get-Changes-All privileges

# retrieve *most* users who can perform DC replication for dev.<Domain>.local (i.e. DCsync)
Get-DomainObjectAcl "dc=dev,dc=<Domain>,dc=local" -ResolveGUIDs | ? {
    ($_.ObjectType -match 'replication-get') -or ($_.ActiveDirectoryRights -match 'GenericAll')
}

# retrieve *most* users who can perform DC replication for dev.<Domain>.local (i.e. DCsync)
Get-ObjectACL "DC=<Domain>,DC=local" -ResolveGUIDs | ? {
    ($_.ActiveDirectoryRights -match 'GenericAll') -or ($_.ObjectAceType -match 'Replication-Get')
}
```