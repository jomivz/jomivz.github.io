---
layout: post
title: TA0006 Credentials Steal - Linux
category: pen
parent: cheatsheets
modified_date: 2023-06-08
permalink: /pen/creds/lin
---

**Mitre Att&ck Entreprise**: [TA0006 - Credentials Access](https://attack.mitre.org/tactics/TA0006/)

**Menu**
<!-- vscode-markdown-toc -->
* [services](#services)
	* [krb](#krb)
	* [ldap](#ldap)
* [db](#db)
	* [db-oracle](#db-oracle)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->


## <a name='services'></a>services

### <a name='krb'></a>krb

* extract the ticket:
```
git clone https://github.com/TarlogicSecurity/tickey
```

### <a name='ldap'></a>ldap
- [LDAP-Password-Hunter](https://github.com/oldboy21/LDAP-Password-Hunter)
- [ldapnomnom](https://github.com/lkarlslund/ldapnomnom)

## <a name='db'></a>db

### <a name='db-oracle'></a>db-oracle
- [oracle odat](https://github.com/quentinhardy/odat)
