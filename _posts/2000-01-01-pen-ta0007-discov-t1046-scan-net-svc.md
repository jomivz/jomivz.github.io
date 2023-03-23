---
layout: post
title: TA0007 Discovery - T1046 Network scanning
category: Pentesting
parent: Pentesting
grand_parent: Cheatsheets
modified_date: 2023-03-23
permalink: /:categories/:title/
tags: discovery scan nmap TA0007 T1595 T1046
---

**Mitre Att&ck Entreprise**

* [TA0007 - Discovery](https://attack.mitre.org/tactics/TA0007/)
* [T1046  - Network Service Discovery](https://attack.mitre.org/techniques/T1046/)

<!-- vscode-markdown-toc -->
* [Administrative Services](#AdministrativeServices)
* [WinRM / SMB / RPC](#WinRMSMBRPC)
	* [WinRM](#WinRM)
	* [SMBv2: SIGNING NOT REQUIRED](#SMBv2:SIGNINGNOTREQUIRED)
* [ARP / ICMP / DNS](#ARPICMPDNS)
* [TCP/UDP w/ NMAP](#TCPUDPwNMAP)
	* [NMAP Note 0 : Default Behavior](#NMAPNote0:DefaultBehavior)
	* [NMAP Note 1 : UDP conns](#NMAPNote1:UDPconns)
	* [NMAP Note 2 : TCP conns](#NMAPNote2:TCPconns)
	* [NMAP Note 3 : NSE scripts](#NMAPNote3:NSEscripts)
	* [NMAP Note 4 : Firewall evasion](#NMAPNote4:Firewallevasion)
* [References](#References)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='AdministrativeServices'></a>Administrative Services

![](/assets/images/pen-ta0007-discov-t1046-scan-net-svc.png)

## <a name='WinRMSMBRPC'></a>WinRM / SMB / RPC

### <a name='WinRM'></a>WinRM

- [WinRM nmap script](https://github.com/RicterZ/My-NSE-Scripts/blob/master/scripts/winrm.nse)

### <a name='SMBv2:SIGNINGNOTREQUIRED'></a>SMBv2: SIGNING NOT REQUIRED
```sh
# STEP 1: find smb not signed
nmap -p 445 --script smb2-security-mode 10.0.0.0/24 -o output.txt

# STEP 2: set up impacket/ntlmrelayx
grep -B 9 "not required" output.txt |sed -E '/.*\((.*\..*\..*\..*)\)$/!d' |sed -E 's/.*\((.*\..*\..*\..*)\)$/\1/' > targets.txt
python3 ntlmrelayx.py -tf targets.txt -smb2support
```

## <a name='ARPICMPDNS'></a>ARP / ICMP / DNS

**use-case**: discovering IP assets over a subnet.
```sh
# Active ARP scan
# Send ?
arp-scan 192.168.1.0/24 -I eth0

# PING one host w/ one ICMP echo request
ping -c 1 192.168.1.254    

# PING an IP range w/ FPING
fping -g 192.168.1.0/24

# PING an IP range w/ NMAP and save results to hosts_up file
# Send ICMP timestamp & netmask requests w/ no port scan and no IP reverse lookup 
nmap -PEPM -sP -n -oA hosts_up 192.168.1.0/24 
```

## <a name='TCPUDPwNMAP'></a>TCP/UDP w/ NMAP 

**use-case**: discovering services for assets into the input file ```hosts_up```.
```sh
#? memo pentesting discovery nmap

#? NMAP TCP SYN/Top 100 ports scan
nmap -F -sS -Pn -iL hosts_up -oA nmap_tcp_fastscan 192.168.0.0/24

#? NMAP TCP SYN/Version scan on all port
sudo nmap -sV -Pn -p0- -T4 -A --stats-every 60s -iL hosts_up --reason -oA nmap_tcp_fullscan 192.168.0.0/24

#? NMAP UDP/Fast Scan
nmap -F -sU -Pn -iL hosts_up -oA nmap_udp_fastscan 192.168.0.0/24

#? NMAP UDP/Top 1000 ports scan
nmap -sU -Pn -iL hosts_up -oA nmap_udp_top1000_scan 192.168.0.0/24

#? NMAP UDP scan on all port scan
sudo nmap -sU -Pn -p0- --reason --stats-every 60s --max-rtt-timeout=50ms --max-retries=1 -iL hosts_up -oA nmap_udp_fullscan 192.168.0.0/24
```

### <a name='NMAPNote0:DefaultBehavior'></a>NMAP Note 0 : Default Behavior 

* By default, Windows firewall blocks all ICMP packets and NMAP does not scan hosts not answering to ```ping```.
* Thus use the option ```-Pn``` as workaround

### <a name='NMAPNote1:UDPconns'></a>NMAP Note 1 : UDP conns

* When the target's UDP port is open, (except for well-known port) there is no response from the target. NMAP refers the port as being ```open|filtered```.
* When the target's UDP port is closed, the response expected is an ICMP port unreachable. NMAP refers the port as being ```closed```.
* For well-known UDP port, NMAP will forge payload (instead of empty). In case of response, NMAP refers the port as being ```opened```.
* Due the slowness of scanning UDP connections, run Nmap with the ```--top-ports <number>``` option.

### <a name='NMAPNote2:TCPconns'></a>NMAP Note 2 : TCP conns

* Compare to TCP connect scans, ```SYN``` / ```NULL``` / ```Xmas``` scans have the following common points:
  * it is often not logged by applications listening on open ports.
  * it requires the ability to create raw packets (as opposed to the full TCP handshake), which is a root privilege by default. 
  * When the target's TCP port is open, there is usually no response. Firewall may also respond with no response or with an ICMP port unreachable when ```filtered```.
  * When the target's TCP port is closed, the response expected is an TCP RST if the port is closed.
  * Either TCP port are ```opened``` or ```closed```, Windows OS respond with a TCP RST. 

You may refer to the [RFC 793](https://tools.ietf.org/html/rfc793) to get more information about the TCP protocol.

### <a name='NMAPNote3:NSEscripts'></a>NMAP Note 3 : NSE scripts

NMAP uses the following options for NSE scripts :
* ```--script=<category>``` where category is one of the following values: ```safe```, ```intrusive```, ```vuln```, ```exploit```, ```brute```, ```auth```, ```discoevry```.
* ```--script=<name> --script-args=<arg1>, <arg2>``` where you may refer to the ```/usr/share/nmap/scripts/``` directory or [nmap.org](https://nmap.org/nsedoc/) to get the full list.
* ```--script-help=<name>``` for help on the script.


### <a name='NMAPNote4:Firewallevasion'></a>NMAP Note 4 : Firewall evasion

* ```-f``` : use fragments
* ```-mtu``` : use lower MTU to split packets than 1500 (standard value for ethernet LAN)
* ```--scan-delay <:digit:>ms``` : avoiding time-based alerts.
* ```--badsum```: behavior to test
* ```-S <IP_Address>```: Spoof the source address 

You may refer to the [nmap.org firewall evasion](https://nmap.org/book/man-bypass-firewalls-ids.html) page for futher information.

### <a name='References'></a>Mindmaps

![NMAP Cheatsheet](/assets/images/pen-ta0007-discov-t1046-scan-net-svc.png)
Image credit: [Ignitetechnologies Mindmaps](https://github.com/Ignitetechnologies/Mindmap)

![NMAP Cheatsheet](/assets/images/pen-discov-nmap-cheatsheet.jpg)
Image credit: Mohamed M. Aly

## <a name='References'></a>References

> * [NMAP SANS cheatsheet](https://jmvwork.xyz/docs/purple/TA0007/discovery_network_nmap_cheatsheet_sans.pdf)
