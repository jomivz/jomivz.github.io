---
layout: post
title: TA0006 Credentials Access - Miscellaneous
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2022-12-12
permalink: /:categories/:title/
---

**Mitre Att&ck Entreprise**: [TA0006 - Credentials Access](https://attack.mitre.org/tactics/TA0006/)

**Menu**
<!-- vscode-markdown-toc -->
* [Services](#Services)
* [Scheduled Tasks](#ScheduledTasks)
* [Web Browsers](#WebBrowsers)
* [VNC](#VNC)
* [WinSCP](#WinSCP)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->


## <a name='Services'></a>Services
- [LDAP-Password-Hunter](https://github.com/oldboy21/LDAP-Password-Hunter)
- [ldapnomnom](https://github.com/lkarlslund/ldapnomnom)
- [oracle odat](https://github.com/quentinhardy/odat)

## <a name='ScheduledTasks'></a>Scheduled Tasks

## <a name='WebBrowsers'></a>Web Browsers

- [chrome / mac os](https://github.com/breakpointHQ/chrome-bandit)

## <a name='VNC'></a>VNC

* VNC softwares properties :  

| software | registry key | folder |
|----------|--------------|--------|
| real vnc | HKEY_LOCAL_MACHINE\SOFTWARE\RealVNC\vncserver | |
| TightVNC | HKEY_CURRENT_USER\Software\TightVNC\Server | |
| TigerVNC | HKEY_LOCAL_USER\Software\TigerVNC\WinVNC4 | |
| UltraVNC | | | C:\Program Files\uvnc bvba\UltraVNC\ultravnc.ini |

* Example of download of the ini file:
```
Evil-winRM > download "C:\Program Files\uvnc bvba\UltraVNC\ultravnc.ini" /
```

## <a name='WinSCP'></a>WinSCP