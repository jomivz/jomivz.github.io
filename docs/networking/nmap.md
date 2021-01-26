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
* For well-knowned UDP port, NMAP will forge payload (instead of empty). In case of response, NMAP refers the port as being ```open```.
* Due the slowness of scanning UDP connections, run Nmap with --top-ports <number> enabled.

## Keypoints scanning TCP connections

* Compare to TCP connect scans, ```SYN``` / ```NULL``` / ```Xmas``` scans have the following common points:
** it is often not logged by applications listening on open ports.
** it requires the ability to create raw packets (as opposed to the full TCP handshake), which is a privilege only the root user has by default. 
** When the target's TCP port is open, the response expected is an ICMP port unreachable.
** When the target's TCP port is closed, the response expected is an TCP RST if the port is closed.

You may refer to the [RFC 793](https://tools.ietf.org/html/rfc793) to get more information about the TCP protocol.
