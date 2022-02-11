---
layout: post
title: TA0007 Discovery - T1046 NMAP cheatsheet
category: Pentesting
parent: Pentesting
grand_parent: Cheatsheets
modified_date: 2021-02-05
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* 1. [Keypoints scanning UDP connections](#KeypointsscanningUDPconnections)
* 2. [Keypoints scanning TCP connections](#KeypointsscanningTCPconnections)
* 3. [NSE scripts](#NSEscripts)
* 4. [NMAP Default behavior](#NMAPDefaultbehavior)
* 5. [Firewall evasion](#Firewallevasion)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='KeypointsscanningUDPconnections'></a>Keypoints scanning UDP connections

* When the target's UDP port is open, (except for well-known port) there is no response from the target. NMAP refers the port as being ```open|filtered```.
* When the target's UDP port is closed, the response expected is an ICMP port unreachable. NMAP refers the port as being ```closed```.
* For well-known UDP port, NMAP will forge payload (instead of empty). In case of response, NMAP refers the port as being ```opened```.
* Due the slowness of scanning UDP connections, run Nmap with the ```--top-ports <number>``` option.

##  2. <a name='KeypointsscanningTCPconnections'></a>Keypoints scanning TCP connections

* Compare to TCP connect scans, ```SYN``` / ```NULL``` / ```Xmas``` scans have the following common points:
  * it is often not logged by applications listening on open ports.
  * it requires the ability to create raw packets (as opposed to the full TCP handshake), which is a root privilege by default. 
  * When the target's TCP port is open, there is usually no response. Firewall may also respond with no response or with an ICMP port unreachable when ```filtered```.
  * When the target's TCP port is closed, the response expected is an TCP RST if the port is closed.
  * Either TCP port are ```opened``` or ```closed```, Windows OS respond with a TCP RST. 

You may refer to the [RFC 793](https://tools.ietf.org/html/rfc793) to get more information about the TCP protocol.

##  3. <a name='NSEscripts'></a>NSE scripts

NMAP uses the following options for NSE scripts :
* ```--script=<category>``` where category is one of the following values: ```safe```, ```intrusive```, ```vuln```, ```exploit```, ```brute```, ```auth```, ```discoevry```.
* ```--script=<name> --script-args=<arg1>, <arg2>``` where you may refer to the ```/usr/share/nmap/scripts/``` directory or [nmap.org](https://nmap.org/nsedoc/) to get the full list.
* ```--script-help=<name>``` for help on the script.

##  4. <a name='NMAPDefaultbehavior'></a>NMAP Default behavior

* By default, Windows firewall blocks all ICMP packets and NMAP does not scan hosts not answering to ```ping```.
* Thus use the option ```-Pn``` as workaround

##  5. <a name='Firewallevasion'></a>Firewall evasion

* ```-f``` : use fragments
* ```-mtu``` : use lower MTU to split packets than 1500 (standard value for ethernet LAN)
* ```--scan-delay <:digit:>ms``` : avoiding time-based alerts.
* ```--badsum```: behavior to test
* ```-S <IP_Address>```: Spoof the source address 

You may refer to the [nmap.org firewall evasion](https://nmap.org/book/man-bypass-firewalls-ids.html) page for futher information.
