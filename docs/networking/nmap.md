---
layout: default
title: nmap
parent: Networking
grand_parent: Cheatsheets
nav_order: 4
has_children: true
---

# NMAP cheatsheet

## Keypoints scanning TCP connections

* TCP SYN scans are often not logged by applications listening on open ports, whyy it is also called stealthy scan  
* TCP SYN scans require the ability to create raw packets (as opposed to the full TCP handshake), which is a privilege only the root user has by default. 
* TCP NULL scans (-sN) are set without any flags. The target host should respond with a RST if the port is closed, as per the [RFC 793](https://tools.ietf.org/html/rfc793).
* TCP FIN scan ( flag used to gracefully close an active connection) expects a RST if the port is closed.
* TCP Xmas scans (-sX) send a malformed TCP packet (sets flags PSH, URG and FIN) and expects a RST response for closed ports.

## Keypoints scanning UDP connections

* Due the slowness of scanning UDP connections, run Nmap with --top-ports <number> enabled.

