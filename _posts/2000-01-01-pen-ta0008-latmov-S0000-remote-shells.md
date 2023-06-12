---
layout: post
title: TA0008 Lateral Movement - S0000 - Remote Shells
category: pen
parent: cheatsheets
modified_date: 2023-06-08
permalink: /pen/rshell
---

**Mitre Att&ck Entreprise**: [TA0008 - Lateral Movement](https://attack.mitre.org/tactics/TA0008/)

<!-- vscode-markdown-toc -->
* 1. [tcp](#tcp)
* 2. [powershell](#powershell)
* 3. [rcp](#rcp)
* 4. [smb](#smb)
* 5. [ssh](#ssh)
* 6. [winrm](#winrm)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

** Administrative Services **

![](/assets/images/pen-ta0007-discov-t1046-scan-net-svc.png)

##  2. <a name='powershell'></a>powershell

* [PowerMeUp](https://github.com/ItsCyberAli/PowerMeUp)
* [pwncat](https://github.com/calebstewart/pwncat)
* [PSRemoting](https://www.jmvwork.xyz/sysadmin/sys-win-ps-useful-queries/#PSCredentialinitialization)

##  3. <a name='rcp'></a>rcp

##  4. <a name='smb'></a>smb

### atexec
### dcomexec
### psexec
#### smbexec
### wmiexec

##  5. <a name='ssh'></a>ssh

##  1. <a name='tcp'></a>tcp

##  6. <a name='winrm'></a>winrm

* [Evil-winrm](https://github.com/Hackplayers/evil-winrm):
```
evil-winrm -i $ztarg_computer_ip -u $ztarg_user_name -p $ztarg_user_pass
evil-winrm -i $ztarg_computer_ip -u $ztarg_user_name -H $ztarg_user_nthash
```