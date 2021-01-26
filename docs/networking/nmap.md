---
layout: default
title: nmap
parent: Networking
grand_parent: Cheatsheets
nav_order: 4
has_children: true
---

# NMAP cheatsheet

## Keypoints scanning UDP connections

* When the target's UDP port is open, (except for well-known port) there is no response from the target. NMAP refers the port as being ```open|filtered```.
* When the target's UDP port is closed, the response expected is an ICMP port unreachable. NMAP refers the port as being ```closed```.
* For well-known UDP port, NMAP will forge payload (instead of empty). In case of response, NMAP refers the port as being ```opened```.
* Due the slowness of scanning UDP connections, run Nmap with the ```--top-ports <number>``` option.

## Keypoints scanning TCP connections

* Compare to TCP connect scans, ```SYN``` / ```NULL``` / ```Xmas``` scans have the following common points:
  * it is often not logged by applications listening on open ports.
  * it requires the ability to create raw packets (as opposed to the full TCP handshake), which is a root privilege by default. 
  * When the target's TCP port is open, there is usually no response. Firewall may also respond with no response or with an ICMP port unreachable when ```filtered```.
  * When the target's TCP port is closed, the response expected is an TCP RST if the port is closed.
  * Either TCP port are ```opened``` or ```closed```, Windows OS respond with a TCP RST. 

You may refer to the [RFC 793](https://tools.ietf.org/html/rfc793) to get more information about the TCP protocol.

## NSE scripts

NMAP uses the following options for NSE scripts :
* ```--script=<category>``` where category is one of the following values: ```safe```, ```intrusive```, ```vuln```, ```exploit```, ```brute```, ```auth```, ```discoevry```.
* ```--script=<name> --script-args=<args>``` where you may refer to the [full list](https://nmap.org/nsedoc/).
* ```--script-help=<name>``` for help on the script.
